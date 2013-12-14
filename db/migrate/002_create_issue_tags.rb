class CreateIssueTags < ActiveRecord::Migration
  def change
    create_table :issue_tags do |t|
      t.references :issue
      t.references :tag
    end
    add_index :issue_tags, :issue_id
    add_index :issue_tags, :tag_id
    add_index :issue_tags, [:issue_id, :tag_id], :unique => true
  end
end
