json.array! @searches do |search|
  json.title search.title
  json.url search.decorate.show_page_link
  json.picture search.pictures.first.image.url(:thumb) if search.pictures?
end