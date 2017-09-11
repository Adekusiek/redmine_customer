class CreateLicenses < ActiveRecord::Migration
  def change
    create_table :licenses do |t|
      t.string :license_num
      t.boolean :status
    end
  end
end
