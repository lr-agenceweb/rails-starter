class AddSubtitlePaperclipToVideoSubtitle < ActiveRecord::Migration
  def up
    add_attachment :video_subtitles, :subtitle_fr
    add_attachment :video_subtitles, :subtitle_en
  end

  def down
    remove_attachment :video_subtitles, :subtitle_fr
    remove_attachment :video_subtitles, :subtitle_en
  end
end
