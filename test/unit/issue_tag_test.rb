require File.expand_path('../../test_helper', __FILE__)

class IssueTagTest < ActiveSupport::TestCase

  def someone
    User.where(login: "someone").first
  end

  def admin
    User.where(login: "admin").first
  end

  def bug
    Tracker.where(name: "Bug").first
  end

  def make_project
    @index ||= 0
    @index += 1
    Project.create name: "_#{@index}", identifier: "_#{@index}"
  end

  def make_issue(project)
    Issue.create subject: "_", project: project, tracker: bug, author: someone
  end

  test "should save one tag" do
    issue = make_issue(make_project)
    
    issue.save_tags "tag"
    
    tags = issue.tags
    assert_equal 1, tags.length, "Wrong length for tags"
    assert_equal "tag", tags[0][:name], "Wrong tag name"
  end

  test "should save few tags" do 
    issue = make_issue(make_project)
    
    issue.save_tags "tag 1 ,  tag 2"
    
    tags = issue.tags
    assert_equal 2, tags.length, "Wrong length for tags"
    assert_equal "tag 1", tags[0][:name], "Wrong first tag name"
    assert_equal "tag 2", tags[1][:name], "Wrong second tag name"
  end

  test "should update tags" do 
    issue = make_issue(make_project)
    
    issue.save_tags "tag 1, tag 2"

    tags = issue.tags
    assert_equal 2, tags.length, "Wrong length for tags"

    issue.save_tags "tag 1"

    tags = issue.tags
    
    assert_equal 1, tags.length, "Wrong length for tags"
    assert_equal "tag 1", tags[0][:name], "Wrong tag name"

    issue.save_tags "tag 2, tag 3, tag 4"

    tags = issue.tags
    assert_equal 3, tags.length, "Wrong length for tags"
  end

  test "should remove tags" do 
    issue = make_issue(make_project)
    
    issue.save_tags "tag 1, tag 2"

    tags = issue.tags
    assert_equal 2, tags.length, "Wrong length for tags"

    issue.save_tags ""

    tags = issue.tags
    assert_equal 0, tags.length, "Wrong length for tags"
  end

  test "should save tags and find it in project" do 
    project = make_project
    issue1 = make_issue(project)
    issue2 = make_issue(project)

    issue1.save_tags "tag 1, tag 2, tag 3"
    issue2.save_tags "tag 2, tag 3, tag 4"

    tags = project.tags

    assert_equal 4, tags.length, "Wrong length for tags"
  end

  test "should save tags and find it in projects" do 
    project1 = make_project
    issue1 = make_issue(project1)
    issue2 = make_issue(project1)
    project2 = make_project
    issue3 = make_issue(project2)
    issue4 = make_issue(project2)

    issue1.save_tags "tag 1, tag 2, tag 3"
    issue2.save_tags "tag 2, tag 3, tag 4"
    issue3.save_tags "tag 3, tag 4, tag 5"
    issue4.save_tags "tag 4, tag 5, tag 6"

    tags = Tag.counted
    assert_equal 6, tags.length, "Wrong length for tags"
  end
  
end
