require 'spec_helper'

describe Account do
  it { should     have_valid(:name).when('Brian') }
  it { should_not have_valid(:name).when(nil, '') }
  describe 'email' do
    before { create(:account, :email => 'taken@example.com') }
    it { should     have_valid(:email).when('test@example.com') }
    it { should_not have_valid(:email).when(nil, '', 'test', 'taken@example.com') }
  end
  describe 'username' do
    before { create(:account, :username => 'taken') }
    it { should     have_valid(:username).when('testuser') }
    it { should_not have_valid(:username).when(nil, '', 'test user', 'taken') }
  end
  describe '#purchased_template?' do
    before do
      @template_1 = Template.new
      @template_2 = Template.new
      @account = Account.new
      @account.stubs(:purchased_templates).returns([@template_1])
    end

    it 'returns true for template_1' do
      @account.purchased_template?(@template_1).should be_true
    end

    it 'returns false for template_2' do
      @account.purchased_template?(@template_2).should be_false
    end
  end

  describe 'card methods' do
    before do
      subject.stubs(:last4).returns('1234')
      subject.stubs(:exp_month).returns('1')
      subject.stubs(:exp_year).returns('2012')
    end
    its(:credit_card_disguised_number) { should eq '***********1234' }
    its(:credit_card_expiration_date) { should eq DateTime.parse('January 2012') }
  end

  describe '#customer' do
    context 'when no strip_id' do
      its(:customer) { should be_nil }
    end
    context 'when customer deleted' do
      before do
        subject.stripe_id = '1234'
        customer = Stripe::Customer.new('1234')
        customer[:deleted] = true
        Stripe::Customer.stubs(:retrieve).returns(customer)
      end
      its(:customer) { should be_nil }
    end
    context 'normal customer' do
      before do
        subject.stripe_id = '1234'
        Stripe::Customer.stubs(:retrieve).returns(Stripe::Customer.new('1234'))
      end
      its(:customer) { should be_true }
    end
  end

  describe 'has_active_card?' do
    context 'no customer' do
      before do
        subject.stubs(:customer).returns(nil)
        subject.stubs(:active_card).returns(nil)
      end
      its(:has_active_card?) { should be_false }
    end
    context 'customer but no active card' do
      before do
        subject.stubs(:customer).returns(true)
        subject.stubs(:active_card).returns(nil)
      end
      its(:has_active_card?) { should be_false }
    end
    context 'customer and active card' do
      before do
        subject.stubs(:customer).returns(true)
        subject.stubs(:active_card).returns(true)
      end
      its(:has_active_card?) { should be_true }
    end
  end

  describe '#does_not_have_active_card?' do
    context 'without active card' do
      before { subject.stubs(:has_active_card?).returns(false) }
      its(:does_not_have_active_card?) { should be_true }
    end
    context 'with active card' do
      before { subject.stubs(:has_active_card?).returns(true) }
      its(:does_not_have_active_card?) { should be_false }
    end
  end

  describe 'deployable_templates' do
    before do
      @account = create(:other_account)
      @template_1 = create(:test_template, :developer_cost => 100)
      @template_2 = create(:test_template, :developer_cost => 0)
      @template_3 = create(:test_template, :developer_cost => 100, :account => @account)
      @template_4 = create(:test_template, :developer_cost => 100)
      template_purchase = TemplatePurchase.new(:account => @account, :template => @template_1)
      template_purchase.save(:validate => false)
    end
    it 'returns @template_1 and @template_2 but not @template_3' do
      templates = @account.deployable_templates
      templates.should include(@template_1)
      templates.should include(@template_2)
      templates.should include(@template_3)
      templates.should_not include(@template_4)
    end
  end
end
