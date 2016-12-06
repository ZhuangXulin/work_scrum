class Users::SessionsController < Devise::SessionsController
  skip_before_filter :require_no_authentication, :only => [:create]
  #before_filter :configure_sign_in_params, only: [:create]
  #验证码
  #include SimpleCaptcha::ControllerHelpers

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  #def create
  #  if simple_captcha_valid?
  #    super
  #  else
  #    flash[:alert] = t("simple_captcha.message.error")
  #    self.resource = resource_class.new(sign_in_params)
  #    respond_with_navigational(resource) { render :new }
  #  end 
  #end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end

end
