# encoding: utf-8
module NotesHelper   
  
  def collection_for_note_types_select
    note_types = [[l(:label_crm_note), '']] + [:label_note_type_email, :label_note_type_call, :label_note_type_meeting].each_with_index.collect{|type, i| [l(type), i]}
    context = {:note_types => note_types}
    call_hook(:helper_notes_note_type_label, context)   
    context[:note_types]
  end
  
  def note_type_icon(note)
    note_type_tag = ''
    case note.type_id
    when 0
      note_type_tag = content_tag('span', '', :class => "icon icon-email", :title => l(:label_note_type_email))
    when 1
      note_type_tag = content_tag('span', '', :class => "icon icon-call", :title => l(:label_note_type_call))
    when 2
      note_type_tag = content_tag('span', '', :class => "icon icon-meeting", :title => l(:label_note_type_meeting))
    end  
    context = {:type_tag => note_type_tag, :type_id => note.type_id}
    call_hook(:helper_notes_note_type_tag, context)  
    context[:type_tag].html_safe
  end
  
  def authoring_note(created, author, options={})
    if RedmineContacts.settings[:note_authoring_time] 
      ('<span class="author">' + l(options[:label] || :label_contacts_added_time_by) + ' ' + 
            link_to_user(author) + ', ' + 
            format_time(created) + '<span>').html_safe
    else  
      authoring(created, author, options={})
    end  
  end
  
  def render_contacts_notes(note, project, options={})
    content = ''
    editable = User.current.logged? && (User.current.allowed_to?(:edit_contact_notes, project) || (note.author == User.current && User.current.allowed_to?(:edit_own_contact_notes, project)))
    links = []
    if !note.description.blank?
      links << link_to_in_place_notes_editor(image_tag('edit.png'), "note-#{note.id}", 
                                             { :controller => 'notes', :action => 'edit', :id => note },
                                                :title => l(:button_edit)) if editable
    end
    content << content_tag('div', links.join(' '), :class => 'contextual') unless links.empty?
    content << textilizable(note, :description)
    css_classes = "wiki"
    css_classes << " editable" if editable
    content_tag('div', content.html_safe, :id => "note-#{note.id}", :class => css_classes)
  end
  
  def link_to_in_place_notes_editor(text, field_id, url, options={})
    onclick = "new Ajax.Request('#{url_for(url)}', {asynchronous:true, evalScripts:true, method:'get'}); return false;"
    link_to text, '#', options.merge(:onclick => onclick)
  end
  
  def add_note_url(note_source, project=nil)
     {:controller => 'notes', :action => 'create', :source_id => note_source, :source_type => note_source.class.name, :project_id => project}
  end  
  
  def contacts_thumbnails(obj, options={})     
    return false if !obj || !obj.respond_to?(:attachments)
    options[:size] = options[:size].to_s || "100" 
    size = options[:size]
    options[:size] = options[:size] + "x" + options[:size]  
    # options[:max_width] = size
    # options[:max_heght] = size
    max_file_size = options[:max_file_size] || 300.kilobytes    
    options[:class] = "thumbnail"
    
    s = ""
    # TODO: Regexp does not work 
    images = obj.attachments.select{|att| att.is_contacts_thumbnailable?}
    images = images.select{|att| att.filename.match(options[:regexp])} if options[:regexp]
    images.each do |att_file|  
      attachment_url = url_for :controller => 'attachments', :action => 'download', :id => att_file, :filename => att_file.filename
      contacts_thumbnail_url = url_for(:controller => 'attachments', 
                                        :action => 'contacts_thumbnail', 
                                        :id => att_file, 
                                        :size => size)

      image_url = Redmine::Thumbnail.convert_available?  ? contacts_thumbnail_url : attachment_url
      s << link_to(image_tag(image_url, options), attachment_url, {:title => att_file.filename}) if (att_file.filesize < max_file_size || Redmine::Thumbnail.convert_available?)
    end       
    s.html_safe
  end 
  
  def auto_contacts_thumbnails(obj) 
    s = ""     
    max_file_size = Setting.plugin_redmine_contacts[:max_contacts_thumbnail_file_size].to_i.kilobytes if !Setting.plugin_redmine_contacts[:max_contacts_thumbnail_file_size].blank?
    s << contacts_thumbnails(obj, {:size => 100, :max_file_size => max_file_size}) if Setting.plugin_redmine_contacts[:auto_contacts_thumbnails] 
    s = content_tag(:p, s.html_safe, :class => "thumbnail") if !s.blank?
    s.html_safe
  end    
  
  def note_content(note)    
    s = ""    
    if note.content.length > Note.cut_length
      s << textilizable(truncate(note.content, {:length => Note.cut_length, :omission => "... \"#{l(:label_note_read_more)}\":#{url_for(:controller => 'notes', :action => 'show', :project_id => @project, :id => note)}" })) 
    else  
		  s << textilizable(note, :content)
		end  
		s.html_safe
  end

  def notes_to_csv(notes)
    decimal_separator = l(:general_csv_decimal_separator)
    encoding = l(:general_csv_encoding)
    export = FCSV.generate(:col_sep => l(:general_csv_separator)) do |csv|
      # csv header fields
      headers = [ "#",
                  l(:field_type, :locale => :en),
                  l(:label_date, :locale => :en),
                  l(:field_author, :locale => :en),
                  l(:field_content, :locale => :en)
                  ]
      # Export project custom fields if project is given
      # otherwise export custom fields marked as "For all projects"
      custom_fields = NoteCustomField.all
      custom_fields.each {|f| headers << f.name}
      # Description in the last column
      csv << headers.collect {|c| Redmine::CodesetUtil.from_utf8(c.to_s, encoding) }
      # csv lines
      notes.each do |note|
        fields = [note.id,
                  note.type_id,
                  format_time(note.created_on),
                  note.author.name,
                  note.content
                  ]
        custom_fields.each {|f| fields << show_value(note.custom_value_for(f)) }
        csv << fields.collect {|c| Redmine::CodesetUtil.from_utf8(c.to_s, encoding) }
      end
    end
    export
  end  
  
end
