class AddAttributeToLicenses < ActiveRecord::Migration
  def up
    add_column :licenses, :hil_type_id, :integer
    add_column :licenses, :hil_flag, :boolean
    add_column :licenses, :license_type, :string
  end
end
