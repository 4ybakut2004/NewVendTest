class UsersController < ApplicationController
	before_action :set_user, only: [:show, :edit, :update]
	before_action :signed_in_user, only: [:show, :edit, :update]

	respond_to :html, :json

	def show
	end

	def index
		@users = User.all
		@ng_controller = "Users"

		respond_with @users.collect { |u| u.attributes.merge!({ :employee => u.employee }) }
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(new_user_params)

		respond_to do |format|
		    if @user.save
		    	format.html { redirect_to @user, notice: 'User was successfully created.' }
		        format.js   {}
		        format.json { render json: @user, status: :created, location: @user }
		    else
		    	format.html { render action: 'new' }
		        format.js   {}
		        format.json { render json: @user.errors, status: :unprocessable_entity }
		    end
		end
	end

	def update
		respond_to do |format|
		  if @user.update(user_params)
		    format.html { redirect_to @user, notice: 'User was successfully updated.' }
		    format.json { render json: @user.attributes.merge!({ :employee => @user.employee }), status: :created, location: @user }
		  else
		    format.html { render action: 'edit' }
		    format.json { render json: @user.errors, status: :unprocessable_entity }
		  end
		end
	end

	def signed_in_user
	  redirect_to signin_url, notice: "Пожалуйста, войдите в систему" unless signed_in?
	end

	private
		def set_user
			@user = User.find(params[:id])
		end

		def user_params
			params.require(:user).permit(:employee_id)
		end

		def new_user_params
			params.require(:user).permit(:name, :password, :password_confirmation)
		end

end
