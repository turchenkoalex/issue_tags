module IssueTags
  class ViewIssuesHook < Redmine::Hook::ViewListener
    render_on :view_issues_form_details_bottom, :partial => 'issue_tags/issues/view_issues_form_details_bottom'
    render_on :view_issues_show_details_bottom, :partial => 'issue_tags/issues/view_issues_show_details_bottom'
    render_on :view_issues_index_bottom, :partial => 'issue_tags/issues/view_issues_index_bottom'
    render_on :view_issues_sidebar_issues_bottom, :partial => 'issue_tags/sidebar/view_issues_sidebar_issues_bottom'
  end
end