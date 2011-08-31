in_order_to 'see the warning', message: :warning_message do
  specified_message = the :warning_message

  message_found = recall :alert

  unless specified_message == message_found
    raise "The specified message: #{specified_message} does not match the message found: #{message_found}"
  end
end
