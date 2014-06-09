class AttributesController < ApplicationController
	before_action :set_attribute, only: [:update, :destroy]
	before_action :signed_in_user

	respond_to :html, :json

	def index
		# Передаем во вьюшку имя контроллера AngularJS
		@ng_controller = "Attributes"

		# Формируем ответ
		respond_to do |format|
			# При рендере html страницы ничего не возвращаем
			format.html { }
			# При ответе в формате JSON формируем ответ с записями таблицы
			format.json { render json: Attribute.order("created_at DESC").all.collect { |a| a.attrs } }
		end
	end

	def create
		@attribute = Attribute.new(attribute_params)
		# Получаем из параметров массив с типами сигналов,
		# которые нужно привязать к создаваемому типу атрибута
		messages = params[:messages] || []

		if @attribute.save
			# Если удалось сохранить тип атрибута без ошибок, привязываем к нему типы сигналов
			messages.each do |m|
				message_attribute = MessageAttribute.create(:message_id => m,
					:attribute_id => @attribute.id)
			end
			respond_to do |format|
				format.json { render :json => @attribute.attrs, :status => :created, :location => @attribute }
			end
		else
			# Если не удалось сохранить, формируем ответ с информацией об ошибках
			respond_to do |format|
				format.json { render :json => @attribute.errors, :status => :unprocessable_entity }
			end
		end
	end

	def update
		respond_to do |format|
			if @attribute.update(attribute_params)
				format.json { render json: @attribute.attrs, status: :created }
			else
				format.json { render json: @attribute.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@attribute.destroy
		respond_to do |format|
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
