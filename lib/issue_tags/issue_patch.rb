module IssueTags
  module IssuePatch
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def tags
        IssueTag
          .where(issue_id: id)
          .joins(:tag)
          .order("#{Tag.table_name}.name")
          .select("#{Tag.table_name}.name")
          .collect { |x| { name: x.name } }
      end
    end

    def tags_to_s
      IssueTag
        .where(issue_id: id)
        .joins(:tag)
        .order("#{Tag.table_name}.name")
        .select("#{Tag.table_name}.name")
        .collect(&:name).join ", "
    end

    def save_tags(names)
      IssueTag.save_tags self, names
    end

    module ClassMethods
    end
  end
end