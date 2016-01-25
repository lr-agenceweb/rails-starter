class AddTurnOffTheLightsToVideoSetting < ActiveRecord::Migration
  def change
    add_column :video_settings, :turn_off_the_light, :boolean, default: true, after: :video_background
  end
end
