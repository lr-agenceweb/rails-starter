class RemoveUselessColumnsFromPost < ActiveRecord::Migration[5.0]
  def change
    # Core
    remove_column :menus, :title, :string
    remove_column :settings, :title, :string
    remove_column :settings, :subtitle, :string

    # Posts
    [:posts, :events, :blogs].each do |table|
      remove_column table, :title, :string
      remove_column table, :content, :text
    end

    # Headings
    remove_column :headings, :content, :text

    # Referencement
    remove_column :referencements, :title, :string
    remove_column :referencements, :description, :text
    remove_column :referencements, :keywords, :string

    # Assets
    [:pictures, :slides].each do |table|
      remove_column table, :title, :string
      remove_column table, :description, :text
    end

    # Modules
    remove_column :blog_categories, :name, :string

    [:newsletters, :mailing_messages, :string_boxes].each do |table|
      remove_column table, :title, :string
      remove_column table, :content, :text
    end

    remove_column :mailing_settings, :signature, :text
    remove_column :mailing_settings, :unsubscribe_title, :string
    remove_column :mailing_settings, :unsubscribe_content, :text

    remove_column :newsletter_settings, :title_subscriber, :string
    remove_column :newsletter_settings, :content_subscriber, :text
    remove_column :newsletter_user_roles, :title, :string
  end
end
