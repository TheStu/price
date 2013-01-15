class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.integer :user_id
      t.string :product_sku
      t.integer :merchant_id
      t.integer :price_cents

      t.timestamps
    end
    add_index :alerts, [:user_id, :merchant_id]
  end
end
