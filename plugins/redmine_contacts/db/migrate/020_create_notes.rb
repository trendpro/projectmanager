class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.string   :subject
      t.text     :content
      t.integer  :source_id
      t.string   :source_type
      t.integer  :author_id
      t.datetime :created_on
      t.datetime :updated_on
    end
    add_index :notes, [:source_id, :source_type]
    add_index :notes, [:author_id]
    
  end

  def self.down
    drop_table :notes
  end
end
