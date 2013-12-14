class IssueTag < ActiveRecord::Base
  unloadable

  validates :issue_id, presence: true
  validates :tag_id, presence: true

  belongs_to :tag
  belongs_to :issue

  def self.save_tags(issue, names)
    tags = names.split(",").map{ |x| x.strip }
    self.transaction do
      if tags.empty?
        self
          .where("issue_id = ?", issue.id)
          .delete_all
        #cleanup unused tags only on full delete for any issue
        Tag.cleanup
      else
        tag_ids = []
        tags.each do |name|
          tag = Tag.find_or_create_by_name(name)
          IssueTag.find_or_create_by_issue_id_and_tag_id issue.id, tag.id
          tag_ids << tag.id
        end
        self
          .where("issue_id = ? and tag_id not in (?)", issue.id, tag_ids)
          .delete_all
      end
    end
  end

end
