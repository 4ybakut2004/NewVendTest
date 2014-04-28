class AddAuditionEnteringDateColumnToRequestTasks < ActiveRecord::Migration
  def change
  	add_column :request_tasks, :audition_entering_date, :datetime
  end
end
