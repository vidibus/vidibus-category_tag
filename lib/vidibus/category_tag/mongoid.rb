module Vidibus
  module CategoryTag
    module Mongoid
      extend ActiveSupport::Concern

      included do
        field :tags_hash, :type => Hash, :default => {}
        before_save :save_category_tags
      end

      module ClassMethods
        def tags_separator(separator = nil)
          @tags_separator = separator if separator
          @tags_separator || ','
        end
      end

      def tags
        (tags_hash || {}).inject({}) do |categories, (key,tags)|
          categories[key] = tags.join(self.class.tags_separator)
          categories
        end
      end

      def tags=(categories)
        raise Error unless categories.is_a?(Hash)

        hash = {}
        @changed_category_tags ||= {}
        categories.each do |category, tags|
          category = category.to_s
          tags = tags.split(self.class.tags_separator).map(&:strip).reject(&:blank?)
          hash[category] = tags if tags.present?
          if tags_hash[category] != tags
            @changed_category_tags[category] = tags
          end
        end
        self.tags_hash = hash
      end

      private

      # Save all changed category tags.
      def save_category_tags
        return true unless @changed_category_tags
        @changed_category_tags.each do |uuid, tags|
          category = tag_category(uuid)
          next unless category
          category.tags += tags
          category.save
        end
        @changed_category_tags = nil
      end

      # Find tag category by uuid.
      def tag_category(uuid)
        TagCategory.where(:uuid => uuid).first
      end
    end
  end
end
