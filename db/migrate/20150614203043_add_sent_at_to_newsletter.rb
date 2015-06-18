class AddSentAtToNewsletter < ActiveRecord::Migration
  def change
    add_column :newsletters, :sent_at, :datetime, after: :content
  end
end
