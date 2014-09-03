class TodosController < ApplicationController
  # before_action :set_todo, only: [:show, :edit, :update, :destroy]

  # GET /todos
  # GET /todos.json
  def index
    @todos = Todo.all
    # @graph = Koala::Facebook::API.new(ENV['FACEBOOK_ACCESS_TOKEN'])
    # p '*'*50
    # profile = @graph.get_object('me')
    # gender_interest = profile['interested_in']
    # feed = @graph.get_connections("me", "feed")
    # ap feed
    # response = HTTParty.get('https://api.stackexchange.com/2.2/questions?site=stackoverflow')
    # p response
    # p cookies
    # response123 = HTTParty.get('https://graph.facebook.com/v2.1/me?access_token=CAACEdEose0cBAEuBZBMbeR5nenG9wKZCKP8fSWgCpGlntrQ1TuciOa3wj0pi4dFeI9nRmXZCuYMXc7MkoSnszjWsoy3Jt9O6mG7PD9RbZCXEMlMDuFntaKO2ZAYSnwVamWpIiU3m8avjz9OqG2xqwE9JQgq4PsaolUZCHee4ikZANZBsJq1yoLZBZCHXX25AZBSbZANX9HF9vBAi1ZCNJKwACZAhiLh3GZCgloEOz0ZD&fields=id,name,birthday')
    # ap response123.body#, response.code, response.message, response.headers.inspect
    # p '*'*50
    # p @oauth = Koala::Facebook::OAuth.new(ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'])#, ENV['FACEBOOK_CALLBACK_URL'])
    # p '*'*50
    # if session
    #   p "Session here!!!!!!!!!!!!!!!!!!!!!!"
    # end
    # # p cookies
    # p '*'*50
    # # @oauth.get_user_info_from_cookies(cookies)
    # # @access_token = @oauth.get_user_info_from_cookies(cookies)['access_token'] if @oauth.get_user_info_from_cookies(cookies)
    # # get email address with access_token
    # @graph = Koala::Facebook::API.new(@access_token)
    # p @graph
    p '*'*50
    p session[:oauth] = Koala::Facebook::OAuth.new(ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'], ENV['FACEBOOK_CALLBACK_URL'])
    p '*'*50
    p @auth_url = session[:oauth].url_for_oauth_code(permissions: "read_stream,email")
  end

  def callback
    if params[:code]
      session[:access_token] = session[:oauth].get_access_token(params[:code])
    end

    @api = Koala::Facebook::API.new(session[:access_token])
    @graph_data = @api.get_object("me/statuses", "fields"=>"message")
  end

  # GET /todos/1
  # GET /todos/1.json
  def show
  end

  # GET /todos/new
  def new
    @todo = Todo.new
  end

  # GET /todos/1/edit
  def edit
  end

  # POST /todos
  # POST /todos.json
  def create
    @todo = Todo.new(todo_params)

    respond_to do |format|
      if @todo.save
        format.html { redirect_to @todo, notice: 'Todo was successfully created.' }
        format.json { render action: 'show', status: :created, location: @todo }
      else
        format.html { render action: 'new' }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /todos/1
  # PATCH/PUT /todos/1.json
  def update
    respond_to do |format|
      if @todo.update(todo_params)
        format.html { redirect_to @todo, notice: 'Todo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todos/1
  # DELETE /todos/1.json
  def destroy
    @todo.destroy
    respond_to do |format|
      format.html { redirect_to todos_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def todo_params
      params.require(:todo).permit(:content, :done?)
    end
end
