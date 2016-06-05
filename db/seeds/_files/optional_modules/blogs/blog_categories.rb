# frozen_string_literal: true

#
# == Blog categories
#
puts 'Creating Blog categories'
@blog_category = BlogCategory.create!(
  name: 'Non Categorisé',
  slug: 'non-categorise'
)
if @locales.include?(:en)
  BlogCategory::Translation.create!(
    blog_category_id: @blog_category.id,
    locale: 'en',
    name: 'Uncategorized',
    slug: 'uncategorized'
  )
end
