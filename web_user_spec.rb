require 'spec_helper'
require 'web_user'

class TestWebUser
  include WebUser
  def initialize(app_map, browser)
    @application = app_map
    @browser = browser
  end
end

def new_user
  @browser = double()
  @site_map = {
   :home_page     => "http://example.com",
   :name          => { :id    => "name"       }, 
   :submit        => { :value => "Submit Me"  },
   :impersonation => { :id    => "Bo Selecta" },
   :username      => { :id    => "name"       }
  }
  TestWebUser.new @site_map, @browser
end

describe WebUser do

  it 'goes to a url' do
    user = TestWebUser.new({ :home_page => "file://#{TEST_DATA_DIR}/home_page.html" }, Watir::Browser.new)
    user.goto :home_page 
    expected_content = "There are currently no pink frogs residing on this page"
    user.can_see?( expected_content ).should be_true
  end

  it 'fills in a text field' do
    user = new_user
    element = double()
    element.should_receive( :set ).with( "Loga" )
    @browser.should_receive( :text_field ).with( :id => "name" ).and_return( element )
    
    user.enter :name, "Loga" 
  end

  it "tells us the content of a text field" do
    user = new_user
    element = double()
    element.should_receive( :value ).and_return( "Loga" )
    @browser.should_receive( :text_field ).with( :id => "name" ).and_return( element )

    user.whats_the :username, :text_field, :value
  end

  it "tells us the content of a paragraph" do
    user = new_user
    element = double()
    element.should_receive( :text ).and_return( "Loga" )
    @browser.should_receive( :p ).with( :id => "name" ).and_return( element )

    user.whats_the :username, :paragraph, :text
  end

  it "clicks on something" do
    user = new_user
    element = double()
    element.should_receive( :click )
    @browser.should_receive( :button ).with( :value => "Submit Me" ).and_return( element )
    @browser.stub( :alert ) do | block |
      block.call
    end
    user.click_on :submit, :button
  end

  it "tells you when can see something" do
    user = new_user
    something = "some text"
    @browser.should_receive( :text ).and_return( "this is #{something} of interest") 

    user.can_see?( something ).should be_true
  end

  it "tells you when cannot see something" do
    user = new_user
    something = "some other text"
    @browser.should_receive( :text ).and_return( "this is some text, without something" )
    user.can_see?( something ).should be_false
  end

  it "tells you when it can see something in an element" do
    user = new_user
    phrase = "Bob's your uncle" 
    mock_element = double()
    @browser.should_receive( :element ).with( @site_map[:name] ).and_return( mock_element )
    mock_element.should_receive( :text ).and_return( "This is some text with #{phrase}" )

    user.can_see_the?( phrase, in_the: :name ).should be_true
  end

  it "tells you when it cannot see something in an element" do
    user = new_user
    phrase = "a phrase that will not be found in the text" 
    mock_element = double()
    @browser.should_receive( :element ).with( @site_map[:name] ).and_return( mock_element )
    mock_element.should_receive( :text ).and_return( "This is some text" )

    user.can_see_the?( phrase, in_the: :name ).should be_false
  end

  it "gives us the message when an alert box appears" do
    user = new_user
    element = double()
    element.should_receive( :click )
    @browser.should_receive( :button ).with( :value => "Submit Me" ).and_return( element )
    @browser.stub( :alert ) do | block |
      block.call
      "There was an alert"
    end
    message = user.whats_the_alert_message_when_you do
      user.click_on( :submit, :button )
    end
    message.should == "There was an alert"
  end

  it "looks in the available tables for an " do
    
  end

  it "selects something" do
    user = new_user
    element = double()
    element.should_receive( :select ).with "Michael Jackson" 
    @browser.should_receive( :select_list ).with( :id => "Bo Selecta" ).and_return element

    user.choose :impersonation, "Michael Jackson"
  end

  it 'closes the browser' do
    user = new_user
    @browser.should_receive(:close) 

    user.close_the_browser
  end
end
