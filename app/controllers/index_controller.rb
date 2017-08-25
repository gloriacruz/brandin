require 'uri'

get '/' do
  url = URI("https://newsapi.org/v1/articles?source=the-next-web&sortBy=latest&apiKey=#{ENV["NEWS_API"]}")
  # http = Net::HTTP.new(url.host, url.port)
  # request = Net::HTTP::Get.new(url)
  # response = http.request(request)
  response = Net::HTTP.get(url)
  body = JSON.parse(response)
  p body
  @source = body["source"]
  @articles = body["articles"]
  erb :'index'
end

get '/login' do
  url = authenticate_url
  redirect url
end

get '/profile' do
  code = params[:code]
  p "Im logged in with code #{code}"
  access_token = get_oauth.get_access_token(code)
  p "Access token #{access_token}"
  api = LinkedIn::API.new(access_token)
  @me = api.profile
  p @me
  @my_name = "#{@me.first_name} #{@me.last_name}"
  @my_job_titles = @me.headline
  # Get industry
  # TODO: User changing their name or position, what happens?
  @user = User.find_or_create_by(full_name: @my_name, title: @my_job_titles, linkedin_token: access_token)
  login(@user)

  redirect "profile/#{@user.id}"
end

get '/profile/:id' do
  @user = User.find_by(id: params[:id])
  @sources = Source.all
  erb :'profile'
end
