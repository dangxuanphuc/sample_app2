$('#follow_form').html("<%= escape_javascript(render('users/follow', create_relationship: @create_relationship)) %>");
$('#followers').html('<%= @user.followers.count %>');
