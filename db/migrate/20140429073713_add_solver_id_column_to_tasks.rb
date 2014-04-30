class AddSolverIdColumnToTasks < ActiveRecord::Migration
  def change
  	add_column :tasks, :solver_id, :integer
  end
end
