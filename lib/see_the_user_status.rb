in_order_to 'see the user status' do
  text = whats_the :user_status, :div, :text
  text.gsub(/\n/,"").gsub(/\s*Logout\s*/,"")
end
