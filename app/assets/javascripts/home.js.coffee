$ ->
  $(document).on 'click', '.count-comment', ->
    micropost_id = $(@).data('id');
    $("#show-comment-#{micropost_id}").toggle();

$(document).on 'click', 'a#loadMoreComment', (e)->
  e.preventDefault();
  $this = $(@);
  micropost_id = $(@).data('micropost-id');
  offset = $(@).data('offset');
  $.ajax
    dataType: 'script'
    url: "/microposts/#{micropost_id}/comments"
    data:
      offset: offset
    success: ->
      $this.data 'offset', offset+2
  return

$(document).on 'click', 'a#show-user-like', (e)->
  e.preventDefault();
  micropost_id = $(@).data('micropost-id');
  console.log(micropost_id);
  $.ajax
    dataType: 'script'
    url: "/microposts/#{micropost_id}/likes"
    data:
      micropost_id: micropost_id
    success: ->
      $("#micropost-counter-#{micropost_id} #likeModal").modal();
  return
