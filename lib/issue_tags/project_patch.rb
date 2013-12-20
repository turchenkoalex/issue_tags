module IssueTags
  module ProjectPatch
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def tags
        IssueTag
          .joins(:issue)
          .where(issues: { project_id: id })
          .joins(:tag)
          .select("#{Tag.table_name}.name, count(*) as cnt")
          .group("#{Tag.table_name}.name")
          .order("cnt desc, #{Tag.table_name}.name")
          .map { |x| 
            { 
              name: x.name, 
              count: x.cnt
            } 
          }
      end
    end

    module ClassMethods
    end
  end
end