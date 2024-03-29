require 'spec_helper'
require 'web_user'

describe WebUser do

  let(:application) { Application.new(
    { :home_page        => "file://#{TEST_DATA_DIR}/home_page.html",
      :name             => { :name => 'name' },
        :flower           => { :id => 'flower' },
        :item_information => { :id => 'information' },
        :color            => { :name => 'color' },
        :description      => { :name  => 'description'},
        :alert            => { :id  => 'alertbutton'},
        :impersonation    => { :id    => "dropdown" },
        :other_page       => { :id    => "other_page" },
        :apples           => { :name    => "apples"   },
        :oranges          => { :id      => "oranges"  },
        :broccoli          => { :id      => "broccoli"  },
        :submit           => { :id => "submit"  }
  })}
  let(:user) { TestWebUser.new(application, browser) }
  let(:browser) { Watir::Browser.new }

  before(:all) do
    user.goto :home_page
  end

  it 'can navigate to a url' do
    expected_content = "There are currently no pink frogs residing on this page"

    user.can_see?( expected_content ).should be_true
  end

  context 'can complete a text field using' do
    it '#fill_in' do
      name = "Grumpy"
      user.fill_in :name, name

      user.whats_the(:name, :text_field, :value).should == name
    end

    it '#enter' do
      name = "Papa Smurf"
      user.enter :name, name

      user.whats_the(:name, :text_field, :value).should == name
    end

    it '#enter_the' do
      name = "Papa Smurf"
      user.enter_the :name, name

      user.whats_the(:name, :text_field, :value).should == name
    end

    it '#scan' do
      flower = "daisy"
      user.scan :flower, flower

      user.whats_the(:flower, :text_field, :value).should == flower
    end
  end

  context 'complains when it cannot find' do

    it 'whats in a paragraph' do
      expect { user.whats_the(:non_existing_element, :paragraph, :text)}.should raise_error
    end

    it 'a submit button' do
      expect { user.click_on(:non_existing_element, :button)}.should raise_error
    end
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

it 'can click elements' do
  user.click_on :other_page, :link

  user.can_see?("The frog ate the cat").should be_true

  user.goto :home_page
end

it "can read the message of an alert box" do
  message = user.whats_the_alert_message_when_you do
    user.click_on :alert, :button
  end

  message.should == "Roses are red"
end

it "can select an element from a drop down list" do
  user.choose(:impersonation, "Michael Jackson").should == "Michael Jackson"
end

{checkbox: :apples, radio: :oranges}.each do | type, element |
  it "can select #{type} element", :focus => true do
    user.select element, type

    user.the_option?(element, type).should be_true
  end
end

it "can deselect a checkbox element" do
  user.deselect :broccoli

  user.the_option?(:broccoli, :checkbox).should be_false
end

it "looks in the available tables for ..."

after(:all) do
  browser.close
end
end

class TestWebUser
  include WebUser
  def initialize(app_map, browser)
    @application = app_map
    @browser = browser
  end
end

class Application
  def initialize elements
    @elements = elements
  end

  def get key
    @elements[key]
  end
end
