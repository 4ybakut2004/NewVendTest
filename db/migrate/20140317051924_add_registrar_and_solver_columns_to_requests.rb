class AddRegistrarAndSolverColumnsToRequests < ActiveRecord::Migration
  def change
  	remove_column :requests, :employee
  	add_column    :requests, :registrar_id, :integer
  	add_column    :requests, :solver_id, :integer
  end
end
