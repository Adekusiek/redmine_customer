class CreateHilTypes < ActiveRecord::Migration
  def change
    create_table :hil_types do |t|
      t.string :code
      t.string :description
    end
  end
end
