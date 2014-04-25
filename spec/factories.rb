FactoryGirl.define do
  factory :user do
    name     "Test Name"
    password "test password"
    password_confirmation "test password"
  end

  factory :machine do
    name "Machine Name"
    uid "UID"
    location "City"
    machine_type "Any Type"
  end

  factory :request do
  	description "Новая заявка"
	phone "89999999999"
	machine_id 0
	registrar_id 0
  end

  factory :request_type do
  	name "С Телефона"
  end

  factory :message do
  	name "Не выдал сдачу"
  	employee_id 0
  	description "Описание"
  end

  factory :task do
  	name "Починить раздатчик"
  	deadline 1
  end

  factory :attribute do
  	name "Примечание"
  	attribute_type "number"
  end

  factory :employee do
  	name "Виктор Викторов"
  end

  factory :request_task do
  	assigner_id 0
    executor_id 0
    auditor_id 0
    description "desc"
    request_message_id 0
    task_id 0
    creation_date nil
    execution_date nil
    audition_date nil
    deadline_date nil
    registrar_description "desc"
    assigner_description "desc"
    executor_description "desc"
    auditor_description "desc"
  end
end