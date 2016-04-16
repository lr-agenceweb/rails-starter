# frozen_string_literal: true
#
# == Homepage [Post]
#
crumb :root do
  link Category.includes(menu: [:translations]).title_by_category('Home'), root_path
end

#
# == About [Post]
#
crumb :abouts do
  link Category.includes(menu: [:translations]).title_by_category('About'), abouts_path
end

crumb :about do |about|
  link about.title, about_path(about)
  parent :abouts
end

#
# == LegalNotice [Post]
#
crumb :legal_notices do
  link Category.includes(menu: [:translations]).title_by_category('LegalNotice'), legal_notices_path
end

#
# == Connection [Post]
#
crumb :connections do
  link Category.includes(menu: [:translations]).title_by_category('Connection'), connections_path
end

#
# == Blog [OptionalModule]
#
crumb :blogs do
  link Category.includes(menu: [:translations]).title_by_category('Blog'), blogs_path
end

crumb :blog do |blog|
  link blog.title, blog_path(blog)
  parent :blogs
end

#
# == GuestBook [OptionalModule]
#
crumb :guest_books do
  link Category.includes(menu: [:translations]).title_by_category('Guestbook'), guest_books_path
end

#
# == Searches [OptionalModule]
#
crumb :searches do
  link Category.includes(menu: [:translations]).title_by_category('Search'), searches_path
end

#
# == Event [OptionalModule]
#
crumb :events do
  link Category.includes(menu: [:translations]).title_by_category('Event'), events_path
end

crumb :event do |event|
  link event.title, event_path(event)
  parent :events
end

#
# == Contact
#
crumb :contact do
  link Category.includes(menu: [:translations]).title_by_category('Contact'), new_contact_path
end
