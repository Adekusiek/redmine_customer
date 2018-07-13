class AddMailFlagToIssues < ActiveRecord::Migration
  def up
    add_column :issues, :auto_close_flag, :boolean, default: true
  end
end
