class WelcomeController < ApplicationController
	##需要token认证的
	before_filter :authenticate_user_from_token!
	##需要正常的cookie认证的
	before_filter :authenticate_user!
	##获取用户权限
	before_action :get_user_role
  #获取默认权限列表
  before_action :get_roles

  def error_404
  	render file: "#{Rails.root}/public/404.html", status: 404, layout: false
  end

  def index
  	
  end
end
