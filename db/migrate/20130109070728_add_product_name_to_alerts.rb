class AddProductNameToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :product_name, :string
  end
end
