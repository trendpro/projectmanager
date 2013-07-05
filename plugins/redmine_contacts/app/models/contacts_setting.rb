class ContactsSetting < ActiveRecord::Base  
  unloadable
  
  belongs_to :project   
  
  cattr_accessor :settings
  acts_as_attachable
  
  # Hash used to cache setting values
  @contacts_cached_settings = {}
  @contacts_cached_cleared_on = Time.now
  
  validates_uniqueness_of :name, :scope => [:project_id]
  
  # Returns the value of the setting named name
  def self.[](name, project_id)
    project_id = project_id.id if project_id.is_a?(Project)
    v = @contacts_cached_settings[hk(name, project_id)]
    v ? v : (@contacts_cached_settings[hk(name, project_id)] = find_or_default(name, project_id).value)
  end
  
  def self.[]=(name, project_id, v)
    project_id = project_id.id if project_id.is_a?(Project)
    setting = find_or_default(name, project_id)
    setting.value = (v ? v : "")
    @contacts_cached_settings[hk(name, project_id)] = nil
    setting.save
    setting.value
  end
  
  # Checks if settings have changed since the values were read
  # and clears the cache hash if it's the case
  # Called once per request
  def self.check_cache
    settings_updated_on = ContactsSetting.maximum(:updated_on)
    if settings_updated_on && @contacts_cached_cleared_on <= settings_updated_on
      clear_cache
    end
  end

    # Clears the settings cache
  def self.clear_cache
    @contacts_cached_settings.clear
    @contacts_cached_cleared_on = Time.now
    logger.info "Contacts settings cache cleared." if logger
  end

  def self.vcard?
    Object.const_defined?(:Vcard)
  end

  def self.spreadsheet?
    Object.const_defined?(:Spreadsheet)
  end
  
  private
  
  def self.hk(name, project_id)
    "#{name}-#{project_id.to_s}"
  end
  
  # Returns the Setting instance for the setting named name
  # (record found in database or new record with default value)
  def self.find_or_default(name, project_id)
    name = name.to_s
    setting = find_by_name_and_project_id(name, project_id)
    setting ||= new(:name => name, :value => '', :project_id => project_id)
  end
  
end
