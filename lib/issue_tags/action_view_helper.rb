module IssueTags
  module ActionViewHelper
    def link_to_tag(tag, project)
      name = tag[:name]
      name += " (#{tag[:count]})" unless tag[:count].nil? || tag[:count] < 2
      if project.nil?
        action =  "javascript:IssueTags.showTag('#{tag[:name]}')"
      else
        action = "javascript:IssueTags.showTag('#{tag[:name]}', '#{project.identifier}')"
      end
      link_to name, action
    end
  end
end