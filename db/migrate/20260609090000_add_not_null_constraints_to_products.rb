class AddNotNullConstraintsToProducts < ActiveRecord::Migration[8.0]
  def up
    change_column_null :products, :inventory_count, false
    change_column_null :products, :name, false
  end

  def down
    change_column_null :products, :name, true
    change_column_null :products, :inventory_count, true
  end
end
