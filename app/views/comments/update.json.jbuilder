json.html render partial: @micropost.comments.includes(:user), formats: [:html, :erb], locals: { micropost: @micropost, comment: @comment }
json.notice_html "<div class='alert alert-success'>Comment was update successfully!</div>"
