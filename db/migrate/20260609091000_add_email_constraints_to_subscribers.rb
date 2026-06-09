class AddEmailConstraintsToSubscribers < ActiveRecord::Migration[8.0]
  def up
    change_column_null :subscribers, :email, false
    add_index :subscribers, [ :product_id, :email ], unique: true
  end

  def down
    remove_index :subscribers, [ :product_id, :email ]
    change_column_null :subscribers, :email, true
  end
end
