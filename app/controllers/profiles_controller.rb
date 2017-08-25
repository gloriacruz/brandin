post '/profiles/:id' do
  # p params.inspect

  @user = User.find(params[:id])
  @user_sources = @user.user_sources
  @selections = params["my-select"]
  @selections = [] if @selections.nil?

  # Delete unselected sources
  @user_sources.each do |user_source|
    if !@selections.include?(user_source.source.code_name)
      p "Deleting #{user_source.source.code_name}"
      user_source.destroy
    end
  end
  # Link selected sources
  @selections.each do |selection|
    source = Source.find_by(code_name: selection)
    if !@user_sources.include?(source)
      p "Adding #{source.code_name}"
      UserSource.create(user_id: @user.id, source_id: source.id)
    end
  end

  redirect "profiles/#{@user.id}"
end

get '/profile' do
  code = params[:code]
  #p "Im logged in with code #{code}"
  access_token = get_oauth.get_access_token(code)
  #p "Access token #{access_token}"
  api = LinkedIn::API.new(access_token)
  @me = api.profile
  @my_name = "#{@me.first_name} #{@me.last_name}"
  @my_job_titles = @me.headline
  # Get industry
  # TODO: User changing their name or position, what happens?
  @user = User.find_or_create_by(full_name: @my_name, title: @my_job_titles, linkedin_token: access_token)
  login(@user)

  redirect "profiles/#{@user.id}"
end

get '/profiles/:id' do
  @user = User.find_by(id: params[:id])
  @sources = Source.all

  erb :'profile'
end

