class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :email
      t.string :family_name
      t.string :given_name
      t.string :title
      t.string :company
      t.string :dept
    end

  end
end
