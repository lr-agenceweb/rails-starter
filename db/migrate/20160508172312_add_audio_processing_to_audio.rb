class AddAudioProcessingToAudio < ActiveRecord::Migration
  def change
    add_column :audios, :audio_processing, :boolean, default: true, after: :online
  end
end
