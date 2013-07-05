class NoteObserver < ActiveRecord::Observer
  def after_create(note)
    if note.source.class == Contact && !note.source.is_company
      parent = Contact.find_by_first_name(note.source.company)
    end
    Mailer.crm_note_add(note, parent).deliver if Setting.notified_events.include?('crm_note_added')
  end
end
