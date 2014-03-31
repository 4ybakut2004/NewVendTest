class StaticPagesController < ApplicationController
  before_action :signed_in_user

  def home
  end

  def help
  end

  def signed_in_user
    redirect_to signin_url, notice: "Пожалуйста, войдите в систему" unless signed_in?
  end
end
