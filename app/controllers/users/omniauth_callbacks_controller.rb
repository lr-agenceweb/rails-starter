#
# == Users namespace
#
module Users
  #
  # == OmniauthCallbacks controller
  #
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def facebook
      redirect_to '/users/auth/facebook?auth_type=rerequest&scope=email' if request.env['omniauth.auth'].info.email.blank?
      omniauth_providers 'facebook'
    end

    private

    def omniauth_providers(provider)
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: provider.capitalize if is_navigational_format?
      else
        session["devise.#{provider}_data"] = request.env['omniauth.auth']
        redirect_to new_user_registration_url
      end
    end
  end
end