require 'redmine'
require_dependency 'issue_tags/view_issues_hook'
require_dependency 'issue_tags/controller_issues_hook'
require_dependency 'issue_tags/issue_query_patch'
require_dependency 'issue_tags/action_view_helper'

Redmine::Plugin.register :issue_tags do
  name 'Issue Tags'
  author 'Turchenko Alexander'
  description 'Add missing tags support for issues'
  version '0.0.2'
  url 'https://github.com/TurchenkoAlex/issue_tags'
  author_url 'https://github.com/TurchenkoAlex'
  settings :default => { 'empty' => true }, :partial => 'issue_tags/settings/issue_tags'
end

Rails.application.config.to_prepare do
  IssueQuery.send(:include, IssueTags::IssueQueryPatch)
  Issue.send(:include, IssueTags::IssuePatch)
  Project.send(:include, IssueTags::ProjectPatch)
  ActionView::Base.send :include, IssueTags::ActionViewHelper
end