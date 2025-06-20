class ApplicationController < ActionController::Base
  before_action :set_browser_support

  private

  def set_browser_support
    browser = Browser.new(request.user_agent)
    redirect_to '/unsupported_browser.html' if browser.bot?  
  end
end