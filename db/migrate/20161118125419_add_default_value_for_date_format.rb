class AddDefaultValueForDateFormat < ActiveRecord::Migration[5.0]
  def change
    change_column_default :settings, :date_format, 0
  end
end
