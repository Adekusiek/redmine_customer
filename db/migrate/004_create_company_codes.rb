class CreateCompanyCodes < ActiveRecord::Migration
  def change
    create_table :company_codes do |t|
      t.string :domain
      t.string :code
    end
  end
end
