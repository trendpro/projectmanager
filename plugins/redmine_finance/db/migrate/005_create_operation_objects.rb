class CreateOperationObjects < ActiveRecord::Migration
  def change
    create_table :operation_objects do |t|
      t.integer :operation_id
      t.integer :operationable_id
      t.string :operationable_type
      t.timestamp :created_at
    end
  end
end
