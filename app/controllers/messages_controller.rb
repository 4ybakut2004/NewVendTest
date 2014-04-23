class MessagesController < ApplicationController
	before_action :set_message, only: [:show, :edit, :update, :destroy]
	before_action :signed_in_user

	respond_to :html, :json

	def index
		@ng_controller = "Messages"

		respond_with Message.all.collect { |m| m.attrs }
	end

	def create
	    @message  = Message.new(message_params)
	    tasks = params[:tasks] || []
	    attributes = params[:attributes] || []
	    request_types = params[:requestTypes] || []
	    new_tasks = params[:new_tasks] || []
	    new_attributes = params[:new_attributes] || []

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

			request_types.each do |rt|
				request_type_message = RequestTypeMessage.create(:message_id => @message.id,
					:request_type_id => rt)
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
	        format.json { render json: @message.attrs, status: :created, location: @message }
	      else
	        format.html { render action: 'new' }
	        format.json { render json: @message.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def update
		tasks = params[:tasks] || []
	    attributes = params[:attributes] || []
	    request_types = params[:requestTypes] || []

		respond_to do |format|
		  if @message.update(message_params)
		  	if params[:messageTasksChanged]
		  	  @message.message_tasks.each { |mt| mt.destroy }
		  	  tasks.each { |task|
		  	  	MessageTask.create(:message_id => @message.id,
					:task_id => task)
		  	  }
		  	end

		  	if params[:messageAttributeChanged]
		  	  @message.message_attributes.each { |ma| ma.destroy }
		  	  attributes.each { |attribute|
		  	  	MessageAttribute.create(:message_id => @message.id,
					:attribute_id => attribute)
		  	  }
		  	end

		  	if params[:messageRequestTypesChanged]
		  	  @message.request_type_messages.each { |rtm| rtm.destroy }
		  	  request_types.each { |rt|
		  	  	RequestTypeMessage.create(:message_id => @message.id,
					:request_type_id => rt)
		  	  }
		  	end

		  	set_message

		    format.html { redirect_to @message, notice: 'Message was successfully updated.' }
		    format.json { render json: @message.attrs, status: :created, location: @message }
		  else
		    format.html { render action: 'edit' }
		    format.json { render json: @message.errors, status: :unprocessable_entity }
		  end
		end
	end

	def destroy
	    @message.destroy
	    respond_to do |format|
	      format.html { redirect_to messages_url }
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
	      params.require(:message).permit(:name, :employee_id)
	    end
end
