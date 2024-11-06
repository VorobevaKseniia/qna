class OauthCallbacksController < Devise::OmniauthCallbacksController

  def oauth
    provider = request.env['omniauth.auth'].provider.capitalize
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  alias_method :github, :oauth
  alias_method :facebook, :oauth
end
