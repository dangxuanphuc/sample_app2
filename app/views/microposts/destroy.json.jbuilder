json.feed_html render partial: 'shared/feed', formats: [:html, :erb]
json.count render partial: 'microposts/micropost_count', formats: [:html, :erb]
json.notice_html "<div class='alert alert-success'>Micropost deleted!</div>"
