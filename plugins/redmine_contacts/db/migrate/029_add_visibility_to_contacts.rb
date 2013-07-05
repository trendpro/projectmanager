class AddVisibilityToContacts < ActiveRecord::Migration
  def up
    add_column :contacts, :visibility, :integer, :default => Contact::VISIBILITY_PROJECT, :null => false

    Contact.find_each(:batch_size => 1000) do |contact|
      contact.tag_list
      contact.save
    end
    
    ContactsSetting.all.each do |setting| 
      setting.value = YAML::load(setting.value.respond_to?(:force_encoding) ? setting.value.force_encoding('utf-8') : setting.value) if setting.value.is_a?(String) rescue  '' 
      setting.save!
    end
  end

  def down
    remove_column :contacts, :visibility
  end
end
