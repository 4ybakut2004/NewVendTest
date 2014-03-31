class MessagesController < ApplicationController
	before_action :set_message, only: [:show, :edit, :update, :destroy]
	before_action :signed_in_user

	def index
		@messages = Message.all
		@message = Message.new
	end

	def create
	    @message  = Message.new(message_params)

	    respond_to do |format|
	      if @message.save
	        format.html { redirect_to @message, notice: 'Message was successfully created.' }
	        format.js   {}
	        format.json { render json: @message, status: :created, location: @message }
	      else
	        format.html { render action: 'new' }
	        format.js   {}
	        format.json { render json: @message.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def destroy
		@messages = Request.all
    
	    @message.destroy
	    respond_to do |format|
	      format.html { redirect_to messages_url }
	      format.js   {}
	      format.json { head :no_content }
    	end
	end

	def signed_in_user
      redirect_to signin_url, notice: "Пожалуйста, войдите в систему" unless signed_in?
    end

	private
	    # Use callbacks to share common setup or constraints between actions.
	    def set_message
	      @message = Message.find(params[:id])
	    end

	    # Never trust parameters from the scary internet, only allow the white list through.
	    def message_params
	      params.require(:message).permit(:name, :request_type)
	    end
end
