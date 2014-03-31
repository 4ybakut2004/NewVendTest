class UsersController < ApplicationController
	before_action :set_user, only: [:show]
	before_action :signed_in_user

	def show
	end

	def signed_in_user
	  redirect_to signin_url, notice: "Пожалуйста, войдите в систему" unless signed_in?
	end

	private
		def set_user
			@user = User.find(params[:id])
		end

end
