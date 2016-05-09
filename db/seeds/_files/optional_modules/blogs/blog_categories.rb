# frozen_string_literal: true

#
# == Blog categories
#
puts 'Creating Blog categories'
@blog_category = BlogCategory.create!(
  name: 'Catégorie 1',
  slug: 'categorie-1'
)
if @locales.include?(:en)
  BlogCategory::Translation.create!(
    blog_category_id: @blog_category.id,
    locale: 'en',
    name: 'Category 1',
    slug: 'category-1'
  )
end
