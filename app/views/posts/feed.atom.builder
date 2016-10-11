# frozen_string_literal: true

# encoding: UTF-8

atom_feed language: @language do |feed|
  extra = @extra_title.blank? ? '' : " (#{@extra_title})"
  feed.title @setting.title + extra
  feed.updated @updated

  @posts.each do |item|
    next if item.updated_at.blank?

    url = item.decorate.show_post_link('url')

    feed.entry(item, url: url) do |entry|
      entry.url item.decorate.show_page_link(true)
      entry.title item.title
      entry.content item.decorate.image_and_content, type: 'html'
      entry.updated(item.updated_at.strftime('%Y-%m-%dT%H:%M:%SZ'))

      entry.author do |author|
        author.name @setting.name
      end
    end
  end
end
