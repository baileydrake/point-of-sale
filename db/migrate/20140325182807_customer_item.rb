class Cart < ActiveRecord::Migration
  def change
    create_table :cart do |t|
      t.belongs_to :product
      t.belongs_to :customer
      t.column :quantity, :int

      t.timestamps
    end
  end
end
