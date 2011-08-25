module BrowserStartup
  def open_a_browser
    if OS.is_unix_based?
      settings = Selenium::WebDriver::Firefox::Profile.new
      settings["network.proxy.type"] = 1
      settings["network.proxy.no_proxies_on"] = "localhost, 127.0.0.1, *.dave"
      @driver = Selenium::WebDriver.for :firefox, :profile => settings
    elsif OS.is_windows?
      @driver = :ie
    end

    @browser = Watir::Browser.new @driver
  end

  class OS
    def is_unix_based?
      is_mac? or is_linux?
    end

    def is_mac?
      RUBY_PLATFORM.downcase.include?("darwin")
    end

    def is_windows?
      RUBY_PLATFORM.downcase.include?("mawin")
    end

    def is_linux
      RUBY_PLATFORM.downcase.include("linux")
    end
  end
end
