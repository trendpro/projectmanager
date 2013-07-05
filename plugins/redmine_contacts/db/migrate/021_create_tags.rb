class CreateTags < ActiveRecord::Migration
  def self.up
    unless ActsAsTaggableOn::Tag.table_exists? 
      create_table :tags do |t|
        t.column :name, :string
      end
      add_index :tags, :name
    end
    add_column :tags, :color, :integer
    add_column :tags, :created_at, :datetime
    add_column :tags, :updated_at, :datetime
    
    unless ActsAsTaggableOn::Tagging.table_exists?  
      create_table :taggings do |t|
        t.column :tag_id, :integer
        t.column :taggable_id, :integer
        t.column :tagger_id, :integer
        t.column :tagger_type, :string
        t.column :taggable_type, :string
        t.string :context, :limit => 128

        t.datetime :created_at
      end

      add_index :taggings, :tag_id
      add_index :taggings, [:taggable_id, :taggable_type, :context]
    end
    
  end
  
  def self.down
    drop_table :taggings
    drop_table :tags
  end
end


