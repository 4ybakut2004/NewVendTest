class MessagesController < ApplicationController
	before_action :set_message, only: [:show, :edit, :update, :destroy]
	before_action :signed_in_user

	respond_to :html, :json

	def index
		@messages = Message.all
		@message = Message.new

		respond_with @messages
	end

	def edit
	end

	def create
	    @message  = Message.new(message_params)
	    tasks = params[:tasks]
	    attributes = params[:attributes]
	    new_tasks = params[:new_tasks]
	    new_attributes = params[:new_attributes]

	    if !tasks
	    	tasks = []
		end

		if !attributes
	    	attributes = []
		end

		if !new_tasks
			new_tasks = []
		end

		if !new_attributes
			new_attributes = []
		end

	    respond_to do |format|
	      if @message.save
	      	tasks.each do |t|
				message_task = MessageTask.create(:message_id => @message.id,
					:task_id => t)
			end

			attributes.each do |a|
				message_attribute = MessageAttribute.create(:message_id => @message.id,
					:attribute_id => a)
			end

			new_tasks.each do |t|
				new_task = Task.create(:name => t)
				message_task = MessageTask.create(:message_id => @message.id,
					:task_id => new_task.id)
			end

			new_attributes.each do |a|
				new_attribute = Attribute.create(:name => a, :attribute_type => Attribute.attribute_types.keys.first)
				message_attribute = MessageAttribute.create(:message_id => @message.id,
					:attribute_id => new_attribute.id)
			end

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

	def update
		respond_to do |format|
		  if @message.update(message_params)
		    format.html { redirect_to @message, notice: 'Message was successfully updated.' }
		    format.js   {}
		    format.json { render json: @message, status: :created, location: @message }
		  else
		    format.html { render action: 'edit' }
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

	def message_group_destroy
		@message_ids = params[:for_destroy]
		Message.where(:id => @message_ids).destroy_all

		respond_to do |format|
		  format.js {}
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
	      params.require(:message).permit(:name, :request_type, :employee_id)
	    end
end
