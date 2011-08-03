require 'scribe'
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
    text = @browser.text
    text.include? something 
  end

  #TODO: merge this functionality into the other can_see method //AM 26-05-2011
  def can_see_the? thing, in_the_element
    element = value_from in_the_element
    @browser.element( application(element) ).text.include?(thing)
  end

  #TODO: remove this spike code //AM 26-05-2011
  def can_see_in_a_table? some_text
    @browser.tables.each do | table |
      table.strings
    end

#    tables_array.each do | table |
#      table.hashes.each do | row_hash |
#        return true if row_hash.has_value? some_text
#      end
#    end
  end

  def click_on element, type
     @browser.alert { @browser.send( type, application(element) ).click }
  end

  def enter into_field, text
    @browser.text_field(:id => into_field.to_s).set text
  end

  def scan into_field, text
    @browser.text_field(:name => into_field.to_s).set text
  end

  def fill_in element, text
    @browser.text_field( application(element) ).set text
  end

  def choose element, choice
    @browser.select_list( application(element) ).select choice
  end

  def whats_the element, type, information
    type = watir_method_for[type] unless watir_method_for[type].nil?

    element = @browser.send( type, application( element ))
    element.send information
  end

  def whats_the_alert_message_when_you &do_this
    do_this.call
  end
  
  def close_the_browser
    @browser.close
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
    @application[element]
  end

  def value_from element_info
    element_info[:in_the]
  end
  #TODO:is this managed on a shared remote submodule?
end
