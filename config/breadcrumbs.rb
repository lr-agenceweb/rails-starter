# frozen_string_literal: true

#
# == Homepage [Post]
#
crumb :root do
  link Page.includes(menu: [:translations]).title_by_page('Home'), root_path
end

#
# == About [Post]
#
crumb :abouts do
  link Page.includes(menu: [:translations]).title_by_page('About'), abouts_path
end

crumb :about do |about|
  link about.title, about_path(about)
  parent :abouts
end

#
# == LegalNotice [Post]
#
crumb :legal_notices do
  link Page.includes(menu: [:translations]).title_by_page('LegalNotice'), legal_notices_path
end

#
# == Connection [Post]
#
crumb :connections do
  link Page.includes(menu: [:translations]).title_by_page('Connection'), connections_path
end

#
# == Blog [OptionalModule]
#
crumb :blogs do
  link Page.includes(menu: [:translations]).title_by_page('Blog'), blogs_path
end

crumb :blog_category do |blog_category|
  link blog_category.name, blog_category_path(blog_category)
  parent :blogs
end

crumb :blog do |blog|
  link blog.title, blog_category_blog_path(blog.blog_category, blog)
  parent blog.blog_category
end

#
# == GuestBook [OptionalModule]
#
crumb :guest_books do
  link Page.includes(menu: [:translations]).title_by_page('Guestbook'), guest_books_path
end

#
# == Searches [OptionalModule]
#
crumb :searches do
  link Page.includes(menu: [:translations]).title_by_page('Search'), searches_path
end

#
# == Event [OptionalModule]
#
crumb :events do
  link Page.includes(menu: [:translations]).title_by_page('Event'), events_path
end

crumb :event do |event|
  link event.title, event_path(event)
  parent :events
end

#
# == Contact
#
crumb :contact do
  link Page.includes(menu: [:translations]).title_by_page('Contact'), new_contact_path
end
