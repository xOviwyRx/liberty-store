class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :email, null: false
      t.string :name, null: false
      t.decimal :total, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
