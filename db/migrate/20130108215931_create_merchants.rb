class CreateMerchants < ActiveRecord::Migration
  def change
    create_table :merchants do |t|
      t.integer :merchant_id
      t.string :merchant_name
      t.string :merchant_url

      t.timestamps
    end
  end
end
