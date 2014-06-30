class ChangeMachinesTable < ActiveRecord::Migration
  def change
    rename_column :machines, :uid, :guid

    remove_column :machines, :machine_type, :string

    add_column :machines, :code, :string
    add_column :machines, :external_code, :string
  end
end
