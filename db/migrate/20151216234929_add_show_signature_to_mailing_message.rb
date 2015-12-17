class AddShowSignatureToMailingMessage < ActiveRecord::Migration
  def change
    add_column :mailing_messages, :show_signature, :boolean, after: :content, default: true
  end
end
