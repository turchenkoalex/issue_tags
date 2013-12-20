module IssueTags
  class ControllerIssuesHook < Redmine::Hook::ViewListener
    def controller_issues_edit_after_save(context={})
      controller_save_tags context
    end

    def controller_issues_new_after_save(context={})
      controller_save_tags context
    end
    
    def controller_issues_bulk_edit_before_save(context={})
      if context[:params] && context[:params][:issue] && context[:issue]
        context[:issue][:savable_tags] = context[:params][:issue][:tags] unless context[:params][:issue][:tags].to_s.empty?
      end
    end

    protected

    def controller_save_tags(context={})
      if context[:params] && context[:params][:issue] && context[:issue]
        tags = context[:params][:issue][:tags].to_s
        issue = context[:issue]
        issue.save_tags tags
      end      
    end
  end
end