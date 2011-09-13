module Vidibus
  module CategoryTag
    module Mongoid
      extend ActiveSupport::Concern

      included do
        field :tags_hash, :type => Hash
      end

      module ClassMethods
        def tags_separator(separator = nil)
          @tags_separator = separator if separator
          @tags_separator || ','
        end
      end

      module InstanceMethods
        def tags
          (tags_hash || {}).inject({}) do |categories, (key,tags)|
            categories[key] = tags.join(self.class.tags_separator)
            categories
          end
        end

        def tags=(categories)
          raise Error unless categories.kind_of?(Hash)

          tags_hash = {}
          categories.each do |category, tags|
            tags = tags.split(self.class.tags_separator).map(&:strip).reject(&:blank?)
            tags_hash[category.to_s] = tags unless tags.empty?
          end
          self.tags_hash = tags_hash
        end
      end
    end
  end
end
