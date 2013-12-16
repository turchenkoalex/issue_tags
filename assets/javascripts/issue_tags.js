(function (window) {
  var IssueTags = IssueTags || {};
  IssueTags.showTag = function(tag, project) {
    queryForm = $("#query_form");
      if (queryForm.length > 0) {
      if ($("#values_tags").length === 0) { 
        addFilter("tags", "~", [tag]); 
      } else {
        $("#cb_tags").attr("checked", true);
        toggleFilter("tags");
        $("#values_tags").val(tag);
      }
      queryForm.submit();
    } else {
      if (project) {
        location.assign("/projects/" + project + "/issues?utf8=✓&set_filter=1&f[]=tags&op[tags]=~&v[tags][]=" + tag);
      } else {
        location.assign("/issues?utf8=✓&set_filter=1&f[]=tags&op[tags]=~&v[tags][]=" + tag);
      }
    }
  };
  window.IssueTags = IssueTags;
})(window);

$(function() {
  $('a.show_tags').on('click', function() {
    $('span.hidden_tag').removeClass('hidden_tag');
    this.remove();
    return false;
  });
});