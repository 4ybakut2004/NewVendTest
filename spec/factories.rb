FactoryGirl.define do
  factory :user do
    name     "Test Name"
    password "test password"
    password_confirmation "test password"
  end

  factory :machine do
    name "Machine Name"
    guid "UID"
  end

  factory :request do
  	description "Новая заявка"
  	phone "89999999999"
  	machine_id 0
  	registrar_id 0

    after(:build) do |request|
      request.machine_id = FactoryGirl.create(:machine).id
      request.registrar_id = FactoryGirl.create(:employee).id
    end
  end

  factory :request_type do
  	name "С Телефона"
  end

  factory :message do
  	name "Не выдал сдачу"
  	description "Описание"
  end

  factory :task do
  	name "Починить раздатчик"
  	deadline 1
    solver_id 0
  end

  factory :attribute do
  	name "Примечание"
  	attribute_type "number"
  end

  factory :employee do
  	name "Виктор Викторов"
    email "test@gmail.com"
    phone "89133976437"
    next_sms_code 1
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

  factory :request_message do
    request_id 0
    message_id 0

    after(:build) do |request_message|
      request_message.request_id = FactoryGirl.create(:request).id
      request_message.message_id = FactoryGirl.create(:message).id
    end
  end

  factory :spiral do
    name "Спираль"
    direction "left"
    mount_priority 1
  end

  factory :motor do
    name "Мотор"
    left_spiral_position 1.0
    right_spiral_position 1.0
    left_bound_offset 1.5
    right_bound_offset 1.5
    mount_priority 1
  end

  factory :model do
    name "Модель"
  end

  factory :shelf do
    name "Полка"
  end

  factory :hole do
    code "Код"
  end

  factory :vendor do
    name "Вендор"
  end

  factory :sales_location do
    name "Имя"
    address "Улица"
  end
end