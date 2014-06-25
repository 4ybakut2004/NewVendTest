class RequestTask < ActiveRecord::Base
    include ActiveModel::Dirty

    PerPage = 10

    belongs_to :task
    belongs_to :request_message

    belongs_to :assigner, :class_name => "Employee", :foreign_key => "assigner_id"
    belongs_to :executor, :class_name => "Employee", :foreign_key => "executor_id"
    belongs_to :auditor, :class_name => "Employee", :foreign_key => "auditor_id"

    before_save :set_audition_entering_date

    validates :description, length: { maximum: 512 }
    validates :registrar_description, length: { maximum: 512 }
    validates :assigner_description, length: { maximum: 512 }
    validates :executor_description, length: { maximum: 512 }
    validates :auditor_description, length: { maximum: 512 }

    def attrs
        request_message = self.request_message
        assigner = self.assigner
        executor = self.executor
        auditor = self.auditor

        fullInfo = self.attributes
        fullInfo["request_id"] = request_message.request_id
        fullInfo["machine_name"] = request_message.request.machine.name
        fullInfo["task_name"] = self.task.name
        fullInfo["assigner_name"] = assigner ? assigner.name : nil
        fullInfo["executor_name"] = executor ? executor.name : nil
        fullInfo["auditor_name"] = auditor ? auditor.name : nil
        fullInfo["checked"] = false;

        return fullInfo
    end

    def getFullInfo
        fullInfo = self.attrs
        fullInfo["request"] = request_message.request.getFullInfo
        fullInfo["attributes"] = request_message.request_attributes.collect { |ra| { :name => ra.attribute.name, :value => ra.value } }
        return fullInfo
    end

    def self.filter(params)
        filter = { }           # Хэш с фильтрами по сотрудникам
        date_filter = []       # Массив со строковыми фильрами по просрочке
        indicators_filter = [] # Массив со строковыми фильтрами по индикаторам
        to_read_filter = []    # Массив со строковыми фильтрами по прочитанности

        # Достаем информацию о фильтрах из параметров
        request_id  = params[:request_id]
        who_am_i = params[:who_am_i] || []
        overdued = params[:overdued] || []
        indicators = params[:indicators] || []
        to_read = params[:to_read] || []

        # Создаем фильтр по заявке
        if request_id != "" && request_id
            filter[:request_messages] = { :request_id => request_id }
        end

        if params[:signed_in]
            # Создаем фильтр по сотрудникам
            if params[:current_employee]
                who_am_i.each do |i|
                    filter[(i + "_id").to_sym] = params[:current_employee].id
                end
            end

            # Создаем фильтр по просроченности
            overdued.each do |type|
                case type
                when "done"
                    date_filter << "execution_date IS NOT NULL AND deadline_date < :date_now"
                when "not_done"
                    date_filter << "execution_date IS NULL AND deadline_date < :date_now"
                end
            end

            # Создаем фильтр по индикаторам
            indicators.each do |type|
                case type
                when "assign"
                    indicators_filter << RequestTask.assign_filter
                when "execute"
                    indicators_filter << RequestTask.execute_filter
                when "audit"
                    indicators_filter << RequestTask.audit_filter
                end
            end

            # Создаем фильтр по записям, которые нужно прочитать
            to_read.each do |tr|
                case tr
                when "assigner"
                    to_read_filter << RequestTask.to_read_assigner_filter
                when "executor"
                    to_read_filter << RequestTask.to_read_executor_filter
                end
            end
        end

        date_now_p = RequestTask.date_now_params
        confirm_time_p = RequestTask.confirm_time_params
        RequestTask.joins(:request_message).order("id DESC").where(filter).where(date_filter.join(' OR '), date_now_p).where(indicators_filter.join(' OR '), date_now_p).where(to_read_filter.join(' OR '), confirm_time_p)
    end

    def self.page(pg, prm)
        pg = pg.to_i
        self.filter(prm).offset((pg-1)*PerPage).limit(PerPage)
    end

    def self.assign_filter
        "executor_id IS NULL OR deadline_date IS NULL"
    end

    def self.execute_filter
        "execution_date IS NULL"
    end

    def self.audit_filter
        "execution_date IS NULL AND deadline_date < :date_now OR execution_date IS NOT NULL AND audition_date IS NULL"
    end

    def self.date_now_params
        { date_now: DateTime.now.utc }
    end

    def self.to_read_assigner_filter
        date_filter = "email_to_executor_date IS NOT NULL AND is_read_by_executor = FALSE "
        # И не просрочили ли они прочтение
        read_confirm_time = NewVendSettings.getSettings.read_confirm_time
        if read_confirm_time
            date_filter += "AND email_to_executor_date < :confirm_time"
        end

        return date_filter
    end

    def self.to_read_executor_filter
        date_filter = "email_to_auditor_date IS NOT NULL AND is_read_by_auditor = FALSE "
        # И не просрочили ли они прочтение
        read_confirm_time = NewVendSettings.getSettings.read_confirm_time
        if read_confirm_time
            date_filter += "AND email_to_auditor_date < :confirm_time"
        end

        return date_filter
    end

    def self.confirm_time_params
        read_confirm_time = NewVendSettings.getSettings.read_confirm_time
        { confirm_time: (DateTime.now - read_confirm_time.minutes).utc }
    end

    def self.to_read_by_assigner_filter
        "email_to_assigner_date IS NOT NULL AND is_read_by_assigner = FALSE "
    end

    def self.to_read_by_auditor_filter
        "email_to_auditor_date IS NOT NULL AND is_read_by_auditor = FALSE "
    end

    def self.to_read_by_executor_filter
        "email_to_executor_date IS NOT NULL AND is_read_by_executor = FALSE "
    end

    def self.to_assign_count(assigner)
        filter = {}
        filter[("assigner_id").to_sym] = assigner.id
        return RequestTask.where(filter).where(RequestTask.assign_filter).size
    end

    def self.to_execute_count(executor)
        filter = {}
        filter[("executor_id").to_sym] = executor.id
        return RequestTask.where(filter).where(RequestTask.execute_filter).size
    end

    def self.to_audit_count(auditor)
        filter = {}
        filter[("auditor_id").to_sym] = auditor.id
        return RequestTask.where(filter).where(RequestTask.audit_filter, { date_now: DateTime.now.utc }).size
    end

    # Возвращает количество непрочитанных поручений,
    # для которых был назначен исполнитель.
    # Информация нужна назначателю
    def self.to_read_assign_count(assigner)
        filter = {}
        date_filter = ""

        # В этих поручениях я являюсь назначателем
        filter[:assigner_id] = assigner.id
        # А так же исполнители их не прочитали
        #filter[:is_read_by_executor] = false
        # Дополнительно проверяем, нужно ли вообще им их читать
        date_filter = to_read_assigner_filter

        return RequestTask.where(filter).where(date_filter, RequestTask.confirm_time_params).size
    end

    # Возвращает количество непрочитанных поручений,
    # у которых была проставлена дата выполнения.
    # Информация нужна исполнителю
    def self.to_read_execute_count(executor)
        filter = {}
        date_filter = ""

        # В этих поручениях я являюсь исполнителем
        filter[:executor_id] = executor.id
        # А так же контролеры их не прочитали
        #filter[:is_read_by_auditor] = false
        # Дополнительно проверяем, нужно ли вообще им их читать
        date_filter = to_read_executor_filter

        return RequestTask.where(filter).where(date_filter, RequestTask.confirm_time_params).size
    end

    def self.to_read_by_executor_count(executor)
        filter = {}
        date_filter = to_read_by_executor_filter
        filter[:executor_id] = executor.id
        return RequestTask.where(filter).where(date_filter).size
    end

    def self.to_read_by_auditor_count(auditor)
        filter = {}
        date_filter = to_read_by_auditor_filter
        filter[:auditor_id] = auditor.id
        return RequestTask.where(filter).where(date_filter).size
    end

    def self.to_read_by_assigner_count(assigner)
        filter = {}
        date_filter = to_read_by_assigner_filter
        filter[:assigner_id] = assigner.id
        return RequestTask.where(filter).where(date_filter).size
    end

    def self.to_read_by_employee_count(employee)
        filter = "assigner_id = #{employee.id} AND " + to_read_by_assigner_filter
        filter += "OR executor_id = #{employee.id} AND " + to_read_by_executor_filter
        filter += "OR auditor_id = #{employee.id} AND " + to_read_by_auditor_filter
        return RequestTask.where(filter).size
    end

    def validate_read_by_assigner(assigner)
        # Необходимо высавить флаг прочтения только тогда,
        # когда читающий, это назначатель,
        # когда оно еще не прочитано
        # и если письмо для подтверждения было отправлено
        assigner.id == self.assigner_id && !self.is_read_by_assigner && self.email_to_assigner_date
    end

    def validate_read_by_executor(executor)
        # Необходимо высавить флаг прочтения только тогда,
        # когда читающий, это исполнитель,
        # когда оно еще не прочитано
        # и если письмо для подтверждения было отправлено
        executor.id == self.executor_id && !self.is_read_by_executor && self.email_to_executor_date
    end

    def validate_read_by_auditor(auditor)
        # Необходимо высавить флаг прочтения только тогда,
        # когда читающий, это контролер,
        # когда оно еще не прочитано
        # и если письмо для подтверждения было отправлено
        auditor.id == self.auditor_id && !self.is_read_by_auditor && self.email_to_auditor_date
    end

    # Отправлять письма нужно только в том случае, если 
    # нужные поля были изменены, а так же все остальные необходимые заполнены

    def needs_send_execute_email
        (self.deadline_date_changed? || self.executor_id_changed? || self.auditor_id_changed?) &&
        assigner_columns_filled
    end

    def assigner_columns_filled
        self.deadline_date && self.executor_id && self.auditor_id
    end

    def needs_send_audit_email
        self.execution_date_changed? && executor_columns_filled
    end

    def executor_columns_filled
        self.execution_date && self.auditor_id
    end

    private
        def set_audition_entering_date
            if self.audition_date != nil
                self.audition_entering_date = DateTime.now
            end
        end
end