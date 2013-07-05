class OperationRelation < ActiveRecord::Base
  unloadable

  belongs_to :operation_source, :class_name => 'Operation', :foreign_key => 'source_id'
  belongs_to :operation_destination, :class_name => 'Operation', :foreign_key => 'destination_id'

  validates_presence_of :operation_source, :operation_destination, :relation_type
  validates_uniqueness_of :destination_id, :scope => :source_id
  validate :validate_operation_relation

  def visible?(user=User.current)
    (operation_source.nil? || operation_source.visible?(user)) && (operation_destination.nil? || operation_destination.visible?(user))
  end

  def deletable?(user=User.current)
    visible?(user) &&
      ((operation_source.nil? || user.allowed_to?(:manage_operation_relations, operation_source.project)) ||
        (operation_destination.nil? || user.allowed_to?(:manage_operation_relations, operation_destination.project)))
  end

  def validate_operation_relation
    if operation_source && operation_destination
      errors.add :destination_id, :invalid if source_id == destination_id
      # detect circular dependencies depending wether the relation should be reversed
      errors.add :base, :circular_dependency if operation_destination.all_dependent_operations.include? operation_source
    end    
  end

  def other_operation(operation)
    (self.source_id == operation.id) ? operation_destination : operation_source
  end  

end
