class AddAudioAutoplayColumnToAudio < ActiveRecord::Migration
  def change
    add_column :audios, :audio_autoplay, :boolean, default: false, after: :audio_updated_at
  end
end
