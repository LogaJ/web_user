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
    { :home_page        => "file://#{TEST_DATA_DIR}/home_page.html",
      :name             => { :id => 'name' },
      :item_information => { :id => 'information' },
      :color            => { :name => 'color' },
      :description      => { :name  => 'description'},
      :alert            => { :id  => 'alertbutton'},
      :submit           => { :id => "submit"  }
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

    it "that they can see a phrase contained in an element" do
      phrase = "what is going on"

      user.can_see_the?(phrase, in_the: :description).should be_true
    end


    it "that they cannot see a phrase when it's not contained in an element" do
      phrase = "a phrase that will not be found in the text"

      user.can_see_the?(phrase, in_the: :description).should be_false
    end
  end

  it 'closes the browser' do
    browser.should_receive(:close)

    user.close_the_browser
  end

  it 'can click elements' do
    element = double
    browser.should_receive(:send).and_return(element)
    element.should_receive(:click)

    user.click_on :submit, :button
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
