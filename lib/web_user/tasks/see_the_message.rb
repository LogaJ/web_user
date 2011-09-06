in_order_to 'See The Message', the: :text do

  Watir::Waiter::wait_until do
    @browser.div(:class, /error_msg|display_msg|info/).exists?
  end

  whats_the :feedback, :paragraph, :text
end

