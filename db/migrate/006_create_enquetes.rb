class CreateEnquetes < ActiveRecord::Migration
  def change
    create_table :enquetes do |t|
      t.date :sent_date, default: Date.today
      t.integer :customer_id
      t.integer :issue_id
      t.integer :project_id
      t.integer :customer_enquete_id      
      t.boolean :recieved_flag, defalut: false
    end
  end
end
