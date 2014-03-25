class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.belongs_to :cashier
      t.belongs_to :cart
      t.column :total, :money

      t.timestamps
    end
  end
end
