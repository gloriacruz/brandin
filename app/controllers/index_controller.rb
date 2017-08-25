require 'uri'

get '/' do

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
  api = LinkedIn::API.new(access_token)
  @me = api.profile
  @my_name = "#{@me.first_name} #{@me.first_name}"
  p @my_name
  @my_job_titles = @me.headline
  @my_location = @me.location
  # url = URI("https://api.linkedin.com/v1/people/~?format=json")
  # p url
  # http=Net::HTTP.new(url.host, url.port)
  # request = Net::HTTP::Get.new(url)
  # response = http.request(request)
  # p response
  # body = JSON.parse(response.read_body)
  # p body
  erb :'profile'
end
