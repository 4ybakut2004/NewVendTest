class NewVendSettingsController < ApplicationController
	before_action :set_new_vend_settings, only: [:show, :update]
	before_action :signed_in_user

	respond_to :html, :json

	def index
		@ng_controller = "Settings"

		respond_to do |format|
			format.html { }
      		format.json { render json: NewVendSettings.all }
		end
	end

	def show
		respond_with @new_vend_settings.attributes
	end

	def update
    respond_to do |format|
      if @new_vend_settings.update(new_vend_settings_params)
        format.html { redirect_to @new_vend_settings, notice: 'settings was successfully updated.' }
        format.json { render json: @new_vend_settings, status: :created }
      else
        format.html { render action: 'index' }
        format.json { render json: @new_vend_settings.errors, status: :unprocessable_entity }
      end
    end
  end

	def signed_in_user
    redirect_to signin_url, notice: "Пожалуйста, войдите в систему" unless signed_in?
  end

  private

  	def set_new_vend_settings
			@new_vend_settings = NewVendSettings.find(params[:id])
		end

    def new_vend_settings_params
			params.require(:new_vend_setting).permit(:read_confirm_time)
		end
end
