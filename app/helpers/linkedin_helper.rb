helpers do

  def configureLinkedin
    LinkedIn.configure do |config|
      config.client_id     = ENV["LINKEDIN_CLIENT_ID"]
      config.client_secret = ENV["LINKEDIN_CLIENT_SECRET"]
      # This must exactly match the redirect URI you set on your application's
      # settings page. If your redirect_uri is dynamic, pass it into
      # `auth_code_url` instead.
      config.redirect_uri  = "http://127.0.0.1:9393/profile"
    end
  end

  def authenticate_url
    configureLinkedin
    oauth = LinkedIn::OAuth2.new
    url = oauth.auth_code_url
  end

  def get_oauth
    configureLinkedin
    oauth = LinkedIn::OAuth2.new
  end

end
