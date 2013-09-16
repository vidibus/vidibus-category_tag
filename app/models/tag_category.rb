class TagCategory
  include Mongoid::Document
  include Mongoid::Timestamps
  include Vidibus::Uuid::Mongoid

  field :label
  field :callname
  field :context, :type => Array, :default => []
  field :tags, :type => Array, :default => []
  field :position, :type => Integer

  before_validation :set_callname, :if => :label
  before_validation :cleanup_tags, :if => :tags
  before_create :set_position

  validates :label, :callname, :presence => true

  scope :sorted, order_by([:position, :asc])

  index({position: 1})
  index({context: 1, callname: 1})

  class << self
    def context(context_hash)
      return all if context_hash.blank?
      all_in(:context => context_list(context_hash))
    end
    alias :in_context :context

    def context_list(context_hash)
      return [] unless context_hash
      return context_hash if context_hash.is_a?(Array)
      context_hash.map { |key,value| "#{key}:#{value}" }
    end

    def sort!(order)
      unless order && order.is_a?(Array)
        raise('Array of uuids in order required')
      end
      uuids = order.map { |i| i[/([^\-]{32})$/, 1]}
      uuids.each_with_index do |uuid, index|
        if item = where(:uuid => uuid).first
          # item.set(:position, index) # TODO: does not work in reality?
          item.update_attribute(:position, index+1)
        end
      end
      destroy_all(:conditions => {:uuid.nin => uuids})
    end
  end

  private

  def set_callname
    self.callname ||= label.parameterize
  end

  def cleanup_tags
    self.tags.uniq!
  end

  def set_position
    return true if position
    self.position = TagCategory.where(:context => context).count + 1
  end
end
