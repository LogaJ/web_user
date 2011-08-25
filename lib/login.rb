in_order_to 'login', as: :name, with_password: :pass do
  username = the :name
  password = username if the( :pass ).nil?
  password = the :pass if password.nil?
  enter :username, username
  enter :password, password
  click_on :login, :button
end
