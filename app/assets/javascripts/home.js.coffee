$ ->
  $(document).on 'click', '.count-comment', ->
    micropost_id = $(@).data('id')
    $("#show-comment-#{micropost_id}").toggle()

# load comment
$(document).on 'click', 'a#loadMoreComment', (e)->
  e.preventDefault()
  $this = $(@)
  micropost_id = $this.data('micropost-id')
  childClosest = $this.closest('.show-comment').find('a#loadMoreComment')
  offset = childClosest.data('offset')
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
      $("div[id^=like-btn-#{micropost_id}].like-btn").html(data.html)

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
      $("div[id^=like-btn-#{micropost_id}].like-btn").html(data.html)

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

# create comment
$(document).on 'keypress', '.comment_form input[id^=comment-content]', (e) ->
  if e.keyCode == 13
    e.preventDefault()
    $this = $(@)
    micropost_id = $this.attr('id').replace(/comment-content-/, '')
    cmtComment = $this.val()
    formData = new FormData()
    formData.append("comment[content]", cmtComment)
    $.ajax
      dataType: 'json'
      method: 'POST'
      url: "/microposts/#{micropost_id}/comments"
      data: formData
      contentType: false
      processData: false
      success: (data) ->
        $("div[id^=comments-#{micropost_id}].comment_content").html(data.html)
        $this.val('')
        $("span[id^=count-comment-#{micropost_id}].count-comment").html(data.count)
        $('#notice').show()
        $('#notice').html(data.notice_html)
        $('#notice').fadeOut(5000)

# edit comment
$(document).on 'click', 'a[id^=edit-comment]', (e) ->
  e.preventDefault()
  micropost_id = $(@).attr('class').replace(/edit-comment-micropost-/, '')
  comment_id = $(@).attr('id').replace(/edit-comment-/, '')
  childClosest = $(@).closest("#comment").find(".edit-comment")
  $.ajax
    dataType: 'json'
    method: 'GET'
    url: "/microposts/#{micropost_id}/comments/#{comment_id}/edit"
    success: (data) ->
      childClosest.html(data.form)

# update comment
$(document).on 'keypress', 'div[id^=comment-id] input[id^=comment-content]', (e) ->
  if e.keyCode == 13
    e.preventDefault()
    comment_id = $(@).parent().attr('id').replace(/edit_comment_/, '')
    micropost_id = $(@).attr('id').replace(/comment-content-/, '')
    updateComment = $(@).val()
    formData = new FormData()
    formData.append("comment[content]", updateComment)
    $.ajax
      dataType: 'json'
      method: 'PATCH'
      url: "/microposts/#{micropost_id}/comments/#{comment_id}"
      data: formData
      contentType: false
      processData: false
      success: (data) ->
        $("div[id^=comments-#{micropost_id}].comment_content").html(data.html)
        $('#notice').show()
        $('#notice').html(data.notice_html)
        $('#notice').fadeOut(5000)

# delete comment
$(document).on 'click', 'a[id^=destroy-comment]', (e) ->
  e.preventDefault()
  micropost_id = $(@).attr('class').replace(/comment-micropost-/, '')
  comment_id = $(@).attr('id').replace(/destroy-comment-/, '')
  if confirm 'Are you sure?'
    $.ajax
      dataType: 'json'
      method: 'DELETE'
      url: "/microposts/#{micropost_id}/comments/#{comment_id}"
      success: (data) ->
        $("div[id^=comment-#{comment_id}].current-comment").remove()
        $("div[id^=comments-#{micropost_id}].comment_content").html(data.html)
        $("span[id^=count-comment-#{micropost_id}].count-comment").html(data.count)
        $('#notice').show();
        $('#notice').html(data.notice_html)
        $('#notice').fadeOut(5000);

# popup micropost
$(document).on 'click', 'a[id^=timestamp]', (e) ->
  e.preventDefault()
  micropost_id = $(@).attr('id').replace(/timestamp_/, '')
  console.log(micropost_id)
  $.ajax
    dataType: 'json'
    method: 'GET'
    url: "/microposts/#{micropost_id}"
    data:
      micropost_id: micropost_id
    success: (data) ->
      $("#modal_micropost").html(data.modal_html)
      document.getElementById('id01').style.display = 'block'
      # $('.like-modal').remove()

# close modal
$(window).on 'click', (e) ->
  modal = document.getElementById('id01')
  if e.target == modal
    modal.style.display = 'none'
