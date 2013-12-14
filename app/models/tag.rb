class Tag < ActiveRecord::Base
  unloadable

  validates :name, presence: true

  has_many :issue_tags

  def self.counted
    self
      .joins(:issue_tags)
      .select("#{Tag.table_name}.name, count(*) as cnt")
      .group("#{Tag.table_name}.name")
      .order("cnt desc, #{Tag.table_name}.name")
      .collect { |x| 
        {
          name: x.name, 
          count: x.cnt
        }
      }
  end

  def self.cleanup
    Tag
      .where("id not in (select #{IssueTag.table_name}.tag_id from #{IssueTag.table_name})")
      .delete_all
  end
end
