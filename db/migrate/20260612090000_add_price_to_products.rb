class AddPriceToProducts < ActiveRecord::Migration[8.0]
  def up
    add_column :products, :price, :decimal, precision: 10, scale: 2
    execute "UPDATE products SET price = 0"
    change_column_null :products, :price, false
  end

  def down
    remove_column :products, :price
  end
end
