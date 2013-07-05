class CreateOperationCategories < ActiveRecord::Migration
  def change
    create_table :operation_categories do |t|
      t.string :name, :null => false
      t.integer :position
      t.boolean :is_income
    end
  end
end
