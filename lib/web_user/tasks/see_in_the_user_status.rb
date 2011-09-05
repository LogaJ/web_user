in_order_to 'see in the user status', content: :logged_in_text, and_username: :username do
  text = whats_the :user_status, :div, :text
  raise "The content: `#{the :logged_in_text}` is incorrect" unless text.include?(the :logged_in_text)
  raise "The username: `#{the :user_name}` is incorrect" unless text.include?(the :username)
end
