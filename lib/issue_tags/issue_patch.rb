module IssueTags
  module IssuePatch
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      base.send(:after_save, :save_issue_tags_after_save_issue)
      base.class_eval do
        alias_method_chain :copy, :tags
      end
    end

    module InstanceMethods
      def tags
        IssueTag
          .where(issue_id: id)
          .joins(:tag)
          .order("#{Tag.table_name}.name")
          .select("#{Tag.table_name}.name")
          .map { |x| { name: x.name } }
      end

      def tags_to_s
        IssueTag
          .where(issue_id: id)
          .joins(:tag)
          .order("#{Tag.table_name}.name")
          .select("#{Tag.table_name}.name")
          .map(&:name).join ", "
      end
      
      def save_tags(names)
        IssueTag.save_tags self, names
      end
      
      def save_issue_tags_after_save_issue
        self.save_tags self[:savable_tags] unless self[:savable_tags].to_s.empty?
      end

      def copy_with_tags(attributes=nil, copy_options={})
        copy = copy_without_tags(attributes, copy_options)
        tags_copy = self.tags_to_s
        copy[:savable_tags] = tags_copy unless tags_copy.empty?
        copy
      end
    end

    module ClassMethods
    end
  end
end