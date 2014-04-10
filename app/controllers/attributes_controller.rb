class AttributesController < ApplicationController
	before_action :set_attribute, only: [:update, :destroy]
	before_action :signed_in_user

	respond_to :html, :json

	def index
		@attributes = Attribute.order("created_at DESC").all

		@ng_controller = "Attributes"

    	respond_with @attributes.collect { |a| a.attrs }
	end

	def create
		@attribute = Attribute.new(attribute_params)
		messages = params[:messages]
		if !messages
			messages = []
		end

		if @attribute.save
			messages.each do |m|
				message_attribute = MessageAttribute.create(:message_id => m,
					:attribute_id => @attribute.id)
			end
			respond_with(@attribute.attrs, :status => :created, :location => @attribute)
		else
			respond_with(@attribute.errors, :status => :unprocessable_entity)
		end
	end

	def update
		respond_to do |format|
		  if @attribute.update(attribute_params)
		    format.html { redirect_to @attribute, notice: 'Task was successfully updated.' }
		    format.json { render json: @attribute.attrs, status: :created }
		  else
		    format.html { render action: 'edit' }
		    format.json { render json: @attribute.errors, status: :unprocessable_entity }
		  end
		end
	end

	def destroy
		@attribute.destroy
	    respond_to do |format|
	      format.html { redirect_to attributes_url }
	      format.json { render json: @attribute.attrs }
	    end
	end

	def signed_in_user
      redirect_to signin_url, notice: "Пожалуйста, войдите в систему" unless signed_in?
    end

	private

		def set_attribute
			@attribute = Attribute.find(params[:id])
		end

		def attribute_params
			params.require(:attribute).permit(:name, :attribute_type)
		end
end
