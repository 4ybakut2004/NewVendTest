class DeleteSolverIdColumnFromRequests < ActiveRecord::Migration
  def change
  	remove_column :requests, :solver_id
  end
end
