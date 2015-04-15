crumb :root do
  link Category.includes(:translations).title_by_category('Home'), root_path
end

crumb :abouts do
  link Category.includes(:translations).title_by_category('About'), abouts_path
end

crumb :about do |about|
  link about.title, about_path(about)
  parent :abouts
end

crumb :contact do
  link Category.includes(:translations).title_by_category('Contact'), new_contact_path
end
