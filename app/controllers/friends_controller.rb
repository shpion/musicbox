class FriendsController < ApplicationController
  before_action :set_friend, only: [:edit, :update, :destroy, :new_request_show]
  before_filter :authenticate_user!

  # GET /friends
  # GET /friends.json
  def index
    @friends = Friend.where("user_id = #{current_user.id} OR friend_id = #{current_user.id}")
  end

  # GET /friends/1
  # GET /friends/1.json
  def show
    @friend_info = User.find(params[:id])
    @friend_records = MyRecord.where("user_id = #{params[:id]}")
  end

  # GET /friends/new
  def new
    @friend = Friend.new

    friends = Friend.where("user_id = #{current_user.id} OR friend_id = #{current_user.id}")
    ids = Array.new
    friends.each do |friend|
      ids.push(friend.user_id)
      ids.push(friend.friend_id)
    end
    ids.push(current_user.id)

    @users = User.where("id NOT IN (?)", ids)

    p @users
    # @users = Array.new
    # users_tmp.each do |user_tmp|
    #   @users.push(user_tmp)
    # end

  end

  # GET /friends/1/edit
  def edit
  end

  def add_record

    id = params[:id]
    friend = Friend.where("user_id=#{current_user.id} AND friend_id=#{id}")

    record = MyRecord.find(params[:rec_id])

    new_record = MyRecord.new({:user_id => current_user.id, :name => record.name, :unic_name => record.unic_name, :size => record.size, :author => record.author, :converted => record.converted, :file_name => record.file_name})

    respond_to do |format|
      if friend
        if new_record.save
          format.html { redirect_to "/friends/#{id}", notice: 'Record was successfully added.' }
          format.json { render :show, status: :created, location: @friend }
        else
          format.html { render "/friends/#{id}", alert: 'Unknown error' }
          format.json { render json: @friend.errors, status: :unprocessable_entity }
        end
      else
        format.html { render "/friends/#{id}", alert: 'You are not a friend.'}
        format.json { render json: @friend.errors, status: :unprocessable_entity }
      end

    end
  end

  # POST /friends
  # POST /friends.json
  def create
    friend_exist = Friend.where("user_id=#{params[:id]} AND friend_id=#{current_user.id}")
    p friend_exist.count

    if friend_exist.count > 0
      respond_to do |format|
        if Friend.update(friend_exist[0].id, :active => 1)
          format.html { redirect_to friends_url, notice: 'Friend was successfully added.' }
          format.json { render :show, status: :created, location: friends_url }
        else
          format.html { render :new }
          format.json { render json: @friend.errors, status: :unprocessable_entity }
        end
      end
    else
      @friend = Friend.new({:user_id => current_user.id, :friend_id => params[:id]})
      respond_to do |format|
        if @friend.save
          format.html { redirect_to friends_url, notice: 'Friend was successfully added.' }
          format.json { render :show, status: :created, location: friends_url }
        else
          format.html { render :new }
          format.json { render json: @friend.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /friends/1
  # PATCH/PUT /friends/1.json
  def update
    respond_to do |format|
      if @friend.update(friend_params)
        format.html { redirect_to @friend, notice: 'Friend was successfully updated.' }
        format.json { render :show, status: :ok, location: @friend }
      else
        format.html { render :edit }
        format.json { render json: @friend.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /friends/1
  # DELETE /friends/1.json
  def destroy
    @friend.destroy
    respond_to do |format|
      format.html { redirect_to friends_url, notice: 'Friend was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def new_request
    @friends = Friend.where("friend_id=#{current_user.id} AND active=0")
  end

  def new_request_show
    @friend_info = User.find(@friend.user_id)
    @friend_records = MyRecord.where("user_id = #{@friend.user_id}")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_friend
      @friend = Friend.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def friend_params

      # friend_params.require(:friend).permit(:user_id, :friend_id)
    end


end
