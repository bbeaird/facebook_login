class TodosController < ApplicationController
  include HTTParty

  def index
    session[:oauth] = Koala::Facebook::OAuth.new(ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'], ENV['FACEBOOK_CALLBACK_URL'])
    @auth_url = session[:oauth].url_for_oauth_code(permissions: "user_birthday,user_location,user_relationship_details,user_actions.books,user_actions.music,user_actions.movies")
  end

  def callback
    if params[:code]
      p session[:access_token] = session[:oauth].get_access_token(params[:code])
    end

    @api = Koala::Facebook::API.new(session[:access_token])
    p @graph_data = @api.get_object("me") # nested hash with data requested from permissions, to_json converts to json and stringifies.
    @user = User.new(graph_response: @graph_data.to_json, facebook_access_token: session[:access_token])
    @user.save
  end

  def show_some_data
    @user = JSON.parse(User.last.graph_response)
    @birthday = @user["birthday"]
    @age = ((Time.now - @birthday.to_datetime).to_f/60/60/24/365.25).floor
    @location = @user["location"]["name"]
    @gender = @user["gender"]
  end

  def create_an_ad
    base_uri 'https://graph.facebook.com'
    options = { }
    # uses HTTParty module for requests
    self.class.post('/act_<AD_ACCOUNT_ID>/adgroups', options)
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
