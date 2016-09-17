class AddAnsweringMachineToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :answering_machine, :boolean, default: false, after: :show_file_upload
  end
end
