class TagCategory
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Acts::Tree
  include Vidibus::Uuid::Mongoid

  field :label
  field :callname
  field :context, :type => Array
  field :tags, :type => Array
  field :position, :type => Integer, :default => 0

  validates :label, :callname, :presence => true

  before_validation :set_callname

  acts_as_tree

  def set_callname
    self.callname = label.parameterize if callname.blank?
  end

  def self.context_list(context_hash)
    return [] unless context_hash
    context_hash.map { |key,value| "#{key}:#{value}" }
  end

  def self.context(context_hash)
    return all if context_hash.blank?
    all_in(:context => context_list(context_hash))
  end
end
