class WelcomeController < ApplicationController
	before_filter :authenticate_user!

  def error_404
  	render file: "#{Rails.root}/public/404.html", status: 404, layout: false
  end

  def index
  	
  end
end
