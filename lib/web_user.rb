require 'web_user/version'
require 'watir-webdriver'
require 'watir-webdriver/extensions/alerts'

module WebUser

  def watir_method_for
    { :paragraph => :p }
  end

  def goto page
    @browser.goto application( page )
  end

  def can_see? something
    @browser.text.include? something
  end

  def can_see_the? thing, in_the_element
    element = value_from in_the_element
    @browser.element( application(element) ).text.include?(thing)
  end

  def click_on element, type
    @browser.alert { @browser.send( type, application(element) ).click }
  end

  def fill_in element, text
    @browser.text_field( application(element) ).set text
  end

  alias enter_the fill_in
  alias enter fill_in
  alias scan fill_in

  def choose element, choice
    @browser.select_list( application(element) ).select choice
  end

  def whats_the element, type, information
    type = watir_method_for[type] unless watir_method_for[type].nil?

    element = @browser.send(type, application(element))
    element.send information
  end

  def whats_the_alert_message_when_you &do_this
    do_this.call
  end

  def opt_for element
    @browser.checkbox(application(element)).set
  end

  def opted_for element
    @browser.checkbox(application(element)).set?
  end

  def set_checkbox name
    @browser.checkbox(:name, name).set
  end

  def clear_checkbox name
    @browser.checkbox(:name, name).clear
  end

  def get_element type, value
    element = @browser.element(type, value)
  end

  def can_interact_with element, type, index=0
    hash = application(element)
    key = hash.keys[0]
    value = hash[key]
    @browser.send( type, key => value, :index => index.to_i).visible?
  end

  def trigger element, event
    @browser.element( application(element)).fire_event event
  end

  private

  def application element
    element = @application.get(element)
    raise "Element #{element} of type: #{type} doesn't exist!" if element.nil?
    return element
  end

  def value_from element_info
    element_info[:in_the]
  end
end
