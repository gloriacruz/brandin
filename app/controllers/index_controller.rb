require 'uri'

get '/' do
  @source = ""
  @articles = []
  sort_by = ""
  # TODO: Check status of response!!
  if current_user && current_user.user_sources.length > 0
    current_user.user_sources.each do |user_source|
      sort_by = "&sortBy=latest" if user_source.source.code_name != "recode"
      url = URI("https://newsapi.org/v1/articles?source=#{user_source.source.code_name}#{sort_by}&apiKey=#{ENV["NEWS_API"]}")
      p url
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(url)
      response = http.request(request)
      body = JSON.parse(response.body)
      @source << "| " + body["source"] + " | "
      @articles.push(*body["articles"])
    end
  else
    #Default news from TechCrunch
    url = URI("https://newsapi.org/v1/articles?source=techcrunch&sortBy=latest&apiKey=#{ENV["NEWS_API"]}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    # response = Net::HTTP.get(url)

    # DON'T DO THIS IN PRACTICE!!
    # Should be something more like...
    #
    # http.use_ssl = true
    # pem = File.read("/path/to/my.pem")
    # http.cert = OpenSSL::X509::Certificate.new(pem)
    # http.key  = OpenSSL::PKey::RSA.new(pem)
    # http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    body = JSON.parse(response.body)
    @source = body["source"]
    @articles = body["articles"]
  end
  erb :'index'
end

get '/login' do
  url = authenticate_url
  redirect url
end

get '/logout' do
  logout
  redirect '/'
end

