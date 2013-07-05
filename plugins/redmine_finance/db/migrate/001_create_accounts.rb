class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name, :null => false
      t.text :description
      t.decimal :amount, :precision => 10, :scale => 2
      t.string :currency, :null => false
      t.integer :project_id, :null => false
      t.integer :assigned_to_id
      t.timestamps
    end
  end
end
