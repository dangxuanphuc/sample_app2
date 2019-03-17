if @micropost.errors.present?
  json.error render partial: 'shared/micropost_form', formats: [:html, :erb], locals: { micropost: @micropost }
else
  json.html render partial: 'shared/feed', formats: [:html, :erb]
  json.form render partial: 'shared/micropost_form', formats: [:html, :erb], locals: { micropost: Micropost.new }
  json.notice_html "<div class='alert alert-success'>Micropost created!</div>"
end
