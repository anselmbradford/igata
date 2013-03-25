class Account < ActiveRecord::Base
  class ConfirmationValidator < ActiveModel::EachValidator # :nodoc:
    def initialize(options)
      options[:attributes] = options[:attributes].map { |attribute| "#{attribute}_confirmation" }
      super
    end

    def validate_each(record, attribute, value)
      attribute_to_confirm = attribute.to_s.sub('_confirmation', '')
      confirmed = record.send(attribute_to_confirm)
      if value != confirmed
        human_attribute_name = record.class.human_attribute_name(attribute_to_confirm)
        record.errors.add(attribute, :confirmation, options.merge(:attribute => human_attribute_name))
      end
    end

    def client_side_hash(model, attribute, force = nil)
      attribute_to_confirm = attribute.to_s.split(/_confirmation/)[0]
      human_attribute_name = model.class.human_attribute_name(attribute_to_confirm)
      build_client_side_hash(model, attribute, self.options.dup.merge(:attribute => human_attribute_name))
    end

    def setup(klass)
      klass.send(:attr_accessor, *attributes.map do |attribute|
        attribute unless klass.method_defined?(attribute)
      end.compact)
    end
  end
  class ChargeFailure < StandardError; end
  include EasyAuth::Models::Account

  attr_accessor :card_number, :card_cvc, :card_expiry_month, :card_exipry_year
  attr_accessible :email, :name, :username, :stripe_token

  # Associations
  has_many :templates
  has_many :template_purchases
  has_many :template_demos
  has_many :purchased_templates, :through => :template_purchases, :source => :template, :uniq => true
  has_many :deployed_templates
  has_one  :github_identity, :class_name => 'Identities::Oauth2::Github'

  # FriendlyId
  extend FriendlyId
  friendly_id :username, :use => :slugged

  # Delgators
  delegate :active_card, :to => :customer
  delegate :last4, :exp_month, :exp_year, :to => :active_card

  # Validations
  validates :name, :email, :username, :presence => true
  validates :email, :format => /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  validates :username, :format => /^\w+$/i
  validates :email, :username, :uniqueness => true

  def stripe_token=(stripe_token)
    begin
      if stripe_id.present? && customer = Stripe::Customer.retrieve(stripe_id)
        customer.card = stripe_token
        customer.save
      else
        customer = Stripe::Customer.create(:card => stripe_token, :email => email)
        self.stripe_id = customer.id
      end
    rescue => e
      self.errors.add(:stripe, 'stripe failed')
    end
  end

  def purchase_template(template)
    begin
      if self.stripe_id.present?
        if template.developer_cost_in_cents > 0
          response = Stripe::Charge.create(:amount => template.developer_cost_in_cents, :currency => 'usd',
                                           :customer => self.stripe_id, :description => "Account: #{self.id} - Template: #{template.id}")
          return response['id']
        else
          return 'free'
        end
      else
        raise ChargeFailure
      end
    rescue => e
      false
    end
  end

  def deployable_templates
    joins_values     = purchased_templates.joins_values
    joins_values[-1] = Arel::OuterJoin.new(joins_values.last.left, joins_values.last.right)
    where_values     = purchased_templates.where_values
    where_values[-1] = where_values.last.or(Arel::SqlLiteral.new('templates.developer_cost = 0'))
    where_values[-1] = where_values.last.or(Arel::SqlLiteral.new("templates.account_id = #{self.id}"))
    Template.joins(*joins_values).where(*where_values)
  end

  def card_expiry_month
    Igata::Months[DateTime.current.month - 1]
  end

  def has_active_card?
    customer && active_card
  end

  def does_not_have_active_card?
    !has_active_card?
  end

  def card_expiry_year
    DateTime.current.year
  end

  def credit_card_disguised_number
    '*' * 11 + last4
  end

  def credit_card_expiration_date
    month = Igata::Months.detect { |month| month[1] == exp_month.to_i }[0]
    DateTime.parse("#{month} #{exp_year}")
  end

  def purchased_template?(template)
    purchased_templates.include?(template)
  end

  def customer
    if stripe_id
      @customer ||= Stripe::Customer.retrieve(stripe_id)
      if @customer[:deleted]
        nil
      else
        @customer
      end
    end
  end
end
