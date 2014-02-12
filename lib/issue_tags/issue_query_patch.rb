module IssueTags
  module IssueQueryPatch
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method_chain :initialize_available_filters, :tags

        class << self
          alias_method_chain :available_columns, :tags
        end
      end
    end

    module InstanceMethods
      def initialize_available_filters_with_tags
        initialize_available_filters_without_tags
        @available_filters["tags"] = { label: "tags", type: :text }
      end

      def sql_for_tags_field(field, operator, value)
        names = value.first.split(",").map{ |x| x.strip }
        case operator
        when "~", "!~"
          clause = (operator == "!~") ? "not" : ""

          if Setting.plugin_issue_tags['use_contains'] == "true"
            query = Tag.where(names.map{ |x| ActiveRecord::Base.connection.quote("%" + x + "%") }.map{ |x| "name like #{x}" }.join(" or "))
          else
            query = Tag.where(name: names)
          end

          tag_ids = query.map(&:id).join ","
          return "(#{clause} 1 = 0)" if tag_ids.empty?
          return "#{Issue.table_name}.id #{clause} in (select #{IssueTag.table_name}.issue_id from #{IssueTag.table_name} where #{IssueTag.table_name}.tag_id in (#{tag_ids}))"
        when "*"
          return "exists(select 1 from #{IssueTag.table_name} where #{IssueTag.table_name}.issue_id = #{Issue.table_name}.id)"
        when "!*"
          return "not exists(select 1 from #{IssueTag.table_name} where #{IssueTag.table_name}.issue_id = #{Issue.table_name}.id)"
        end
        ""
      end
    end

    module ClassMethods
      def available_columns_with_tags
        columns = available_columns_without_tags
        has_tags = columns.find_all { |coluna| coluna.name == :tags_to_s }
        columns << QueryColumn.new(:tags_to_s, :caption => l(:tags)) unless has_tags.size() > 0
        columns
      end
    end
  end
end