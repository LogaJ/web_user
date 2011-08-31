in_order_to 'see in the user status', content: :logged_in_text, and_username: :username do
  text = whats_the :user_status, :div, :text
  text.include?(the :logged_in_text)
  text.include?(the :username)
end
