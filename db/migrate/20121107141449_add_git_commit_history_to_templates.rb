class AddGitCommitHistoryToTemplates < ActiveRecord::Migration
  def change
    add_column :templates, :git_commit_history, :string, :array => true, :limit => 40
    add_column :templates, :last_git_action_at, :datetime
  end
end
