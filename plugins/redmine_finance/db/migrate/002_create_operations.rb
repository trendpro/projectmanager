class CreateOperations < ActiveRecord::Migration
  def change
    create_table :operations do |t|
      t.decimal :amount, :precision => 10, :scale => 2, :null => false
      t.integer :category_id, :null => false
      t.integer :account_id, :null => false
      t.integer :contact_id
      t.integer :comments_count
      t.timestamp :operation_date, :null => false
      t.integer :author_id, :null => false
      t.text :description
      t.timestamps
    end
  end
end
