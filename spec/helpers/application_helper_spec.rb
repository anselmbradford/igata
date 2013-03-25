require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ApplicationHelper do
  describe 'can_deploy_template?' do
    context 'no current account' do
      it 'cannot deploy' do
        helper.can_deploy_template?(Template.new).should be_false
      end
    end
    context 'current account' do
      before do
        helper.stubs(:current_account).returns(mock('Account'))
        helper.current_account.stubs(:purchased_template?).returns(false)
        @template = Template.new(:developer_cost => 100)
      end
      context 'when current account purchased template' do
        before { helper.current_account.stubs(:purchased_template?).returns(true) }
        it 'should be deployable' do
          helper.can_deploy_template?(@template).should be_true
        end
      end
      context 'when current account owns template' do
        before do
          templates = mock('template')
          templates.stubs(:exists?).returns(true)
          helper.current_account.stubs(:templates).returns(templates)
        end
        it 'should be deployable' do
          helper.can_deploy_template?(@template).should be_true
        end
      end
    end
  end
end
