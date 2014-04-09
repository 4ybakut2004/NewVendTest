class MessageTasksController < ApplicationController
	before_action :set_message_task, only: [:show, :edit, :update, :destroy]

	respond_to :html, :json

	def index
		@message_tasks = MessageTask.order("created_at DESC").all

    	respond_with @message_tasks
	end
end
