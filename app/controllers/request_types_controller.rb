class RequestTypesController < ApplicationController
	before_action :set_request_type, only: [:show, :edit, :update, :destroy]
  	before_action :signed_in_user

  	respond_to :html, :json

  	def index
  	  @ng_controller = "RequestTypes"

  	  respond_to do |format|
		format.html { }
		format.json { render json: RequestType.order('created_at DESC').collect { |rt| rt.attrs } }
	  end
  	end

  	def show
  		respond_with @request_type.getFullInfo
  	end

  	def create
  		@request_type = RequestType.new(request_type_params)
  		messages = params[:messages] || []

		respond_to do |format|
	      if @request_type.save
	      	messages.each do |m|
				RequestTypeMessage.create(:request_type_id => @request_type.id,
					:message_id => m)
			end

	        format.html { redirect_to @request_type, notice: 'RequestType was successfully created.' }
	        format.json { render json: @request_type.attrs, status: :created, location: @request_type }
	      else
	        format.html { render action: 'new' }
	        format.json { render json: @request_type.errors, status: :unprocessable_entity }
	      end
	    end
  	end

  	def update
  	  messages = params[:messages] || []

	  respond_to do |format|
	    if @request_type.update(request_type_params)

	      if params[:requestTypeMessagesChanged]
		  	@request_type.request_type_messages.each { |rtm| rtm.destroy }
		  	messages.each { |message|
		  	  RequestTypeMessage.create(:request_type_id => @request_type.id,
			  :message_id => message)
		  	}
		  end

		  set_request_type

	      format.html { redirect_to @request_type, notice: 'RequestType was successfully updated.' }
	      format.json { render json: @request_type.attrs, status: :created }
	    else
	      format.html { render action: 'edit' }
	      format.json { render json: @request_type.errors, status: :unprocessable_entity }
	    end
	  end
	end

	def destroy
	  @request_type.destroy
	  respond_to do |format|
	    format.html { redirect_to request_types_url }
	    format.json { render json: @request_type.attrs }
	  end
	end

  	def signed_in_user
	  redirect_to signin_url, notice: "Пожалуйста, войдите в систему" unless signed_in?
	end

	private
	  # Use callbacks to share common setup or constraints between actions.
	  def set_request_type
	    @request_type = RequestType.find(params[:id])
	  end

	  # Never trust parameters from the scary internet, only allow the white list through.
	  def request_type_params
	    params.require(:request_type).permit(:name)
	  end
end
