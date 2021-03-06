class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, 
                                                          :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  #verify that user is an admin
  before_action :admin_user, only: [:destroy]

  #returns index of all users
  def index
    @users = User.paginate(page: params[:page])
  end

  #show user informations in a form for
  def edit
    @user = User.find(params[:id])
  end

#update attributes of a given user
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Votre profile a été mise à jour !"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def show
  	#show user with param given with the url
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  	#debugger : for debug
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      log_in @user
  		flash[:success] = "Bonjour au site e-Learn !"
  		redirect_to @user
  		#save the user
  	else
  		render 'new'
  	end
  end

def destroy
  User.find(params[:id]).destroy
  flash[:success] = "utilisateur supprimé !"
  redirect_to users_url
end

def following
  @title = "Following"
  @user = User.find(params[:id])
  @users = @user.following.paginate(page: params[:page])
  render 'show_follow'
end

def followers
  @title = "Followers"
  @user = User.find(params[:id])
  @users = @user.followers.paginate(page: params[:page])
  render 'show_follow'
end

private
#permit some attributes for security reason
#called strong parameter
	def user_params
	  params.require(:user).permit(:name, :email, :password,:password_confirmation)	
	end

  #confirm a logged_in user
      #removed from here and pasted in: app/controllers/application_controller.rb

  #confirm the correct user
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless  current_user?(@user)
  end

    #confirms a user is an admin
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
  end

