$ ->
  $(document).on 'click', '.count-comment', ->
    console.log($(@));
    micropost_id = $(@).data('id');
    $("#show-comment-#{micropost_id}").toggle();
