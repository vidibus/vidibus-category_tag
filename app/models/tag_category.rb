class TagCategory
  include Mongoid::Document
  include Mongoid::Timestamps
  include Vidibus::Uuid::Mongoid

  field :label
  field :callname
  field :context, :type => Array, :default => []
  field :tags, :type => Array, :default => []
  field :position, :type => Integer, :default => 0

  before_validation :set_callname, :if => :label
  before_validation :cleanup_tags, :if => :tags

  validates :label, :callname, :presence => true

  scope :sorted, order_by([:position, :asc])

  class << self
    def context(context_hash)
      return all if context_hash.blank?
      all_in(:context => context_list(context_hash))
    end

    def context_list(context_hash)
      return [] unless context_hash
      context_hash.map { |key,value| "#{key}:#{value}" }
    end
  end

  private

  def set_callname
    self.callname ||= label.parameterize
  end

  def cleanup_tags
    self.tags.uniq!
  end
end
