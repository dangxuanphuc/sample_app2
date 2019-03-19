json.html render partial: @micropost.comments.includes(:user), formats: [:html, :erb], locals: { micropost: @micropost }
json.count render partial: 'comments/comment_count', formats: [:html, :erb]
json.notice_html "<div class='alert alert-success'>Comment was create successfully!</div>"
