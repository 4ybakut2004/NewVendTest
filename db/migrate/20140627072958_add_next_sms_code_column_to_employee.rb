class AddNextSmsCodeColumnToEmployee < ActiveRecord::Migration
  def change
    add_column :employees, :next_sms_code, :integer, default: 0
  end
end
