$ ->
  $(document).on 'click', '.count-comment', ->
    micropost_id = $(@).data('id')
    $("#show-comment-#{micropost_id}").toggle()

# load comment
$(document).on 'click', 'a#loadMoreComment', (e)->
  e.preventDefault()
  $this = $(@)
  micropost_id = $(@).data('micropost-id')
  offset = $(@).data('offset')
  $.ajax
    dataType: 'script'
    url: "/microposts/#{micropost_id}/comments"
    data:
      offset: offset
    success: ->
      $this.data 'offset', offset+2
  return

# show user like
$(document).on 'click', 'a#show-user-like', (e)->
  e.preventDefault()
  micropost_id = $(@).data('micropost-id')
  $.ajax
    dataType: 'json'
    method: 'GET'
    url: "/microposts/#{micropost_id}/likes"
    data:
      micropost_id: micropost_id
    success: (data) ->
      $("#modal-micropost-#{micropost_id}").html(data.html)
      $("#micropost-counter-#{micropost_id} #likeModal").modal()
  return

# like btn
$(document).on 'click', 'a[id^=like_micropost]', (e)->
  e.preventDefault()
  micropost_id = $(@).attr('id').replace(/like_micropost_/, '')
  $.ajax
    dataType: 'json'
    method: 'POST'
    url: "/microposts/#{micropost_id}/likes"
    success: (data) ->
      $("#like-btn-#{micropost_id}").html(data.html)

# dislike btn
$(document).on 'click', 'a[id^=dislike_micropost]', (e) ->
  e.preventDefault()
  micropost_id = $(@).attr('id').replace(/dislike_micropost_/, '')
  like_id = $(@).attr('class').replace(/like like_/, '')
  $.ajax
    dataType: 'json'
    method: 'DELETE'
    url: "/microposts/#{micropost_id}/likes/#{like_id}"
    success: (data) ->
      $("#like-btn-#{micropost_id}").html(data.html)

# create micropost
$(document).on 'click', 'input#post_micropost', (e) ->
  e.preventDefault()
  postContent = $(@).parent().find('#post_content').val()
  formData = new FormData()
  formData.append("micropost[content]", postContent)
  formData.append("micropost[picture]", $('input[type=file]')[0].files[0])
  $.ajax
    dataType: 'json'
    method: 'POST'
    url: '/microposts'
    data: formData
    contentType: false
    processData: false
    success: (data) ->
      $('.micropost_form').html(data.error)
      $('.microposts').html(data.html)
      $('.micropost_form').html(data.form)
      $('#notice').show()
      $('#notice').html(data.notice_html)
      $('#notice').fadeOut(5000)

# delete micropost
$(document).on 'click', 'a[id^=del_micropost]', (e) ->
  e.preventDefault()
  micropost_id = $(@).attr('id').replace(/del_micropost_/, '')
  if confirm 'Are you sure?'
    $.ajax
      dataType: 'json'
      method: 'DELETE'
      url: "/microposts/#{micropost_id}"
      success: (data) ->
        $("#micropost-#{micropost_id}").remove()
        $('.microposts').html(data.feed_html)
        $('#count_micropost').html(data.count)
        $('#notice').show()
        $('#notice').html(data.notice_html)
        $('#notice').fadeOut(5000)
