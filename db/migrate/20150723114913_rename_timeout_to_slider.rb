class RenameTimeoutToSlider < ActiveRecord::Migration
  def change
    rename_column :sliders, :timeout, :time_to_show
  end
end
