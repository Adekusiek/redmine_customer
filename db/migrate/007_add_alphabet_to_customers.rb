class AddAlphabetToCustomers < ActiveRecord::Migration
  def up
    add_column :customers, :family_name_alphabet, :string
    add_column :customers, :given_name_alphabet, :string
  end
end
