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

  before(:all) do
    user.goto :home_page
  end

  let(:user) { TestWebUser.new(
    { :home_page => "file://#{TEST_DATA_DIR}/home_page.html",
      :name => { :id => 'name' },
      :item_information => { :id => 'information' },
      :color => { :name => 'color' }
  }, browser) }
  let(:browser) { Watir::Browser.new }

  it 'navigates to a url' do
    expected_content = "There are currently no pink frogs residing on this page"

    user.can_see?( expected_content ).should be_true
  end

  it 'fills in a text field' do
    user.fill_in :name, "Loga"

    user.whats_the(:name, :text_field, :value).should == "Loga"
  end

  it 'complains when it cannot find an element' do
    expect { user.whats_the(:non_existing_element, :paragraph, :text)}.should raise_error
  end

  describe 'can read the correct information' do
    it "from paragraph elements" do
      expected_content = 'Blue skirt, red top'

      user.whats_the(:item_information, :paragraph, :text).should == expected_content
    end

    it "from text field elements" do
      expected_content = 'black with white stripes'

      user.whats_the(:color, :text_field, :value).should == expected_content
    end
  end

  describe 'can confirm' do
    it 'that they can see the content that is on the page' do
      existing_content = "There are currently no pink frogs residing on this page"

      user.can_see?(existing_content).should be_true
    end

    it 'that they can not see content that is not on the page' do
      not_existing_content = "The pink ducks went home"

      user.can_see?(not_existing_content).should be_false
    end
  end

  it 'closes the browser' do
    browser.should_receive(:close)

    user.close_the_browser
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

  after(:all) do
    user.close_the_browser
  end
end
