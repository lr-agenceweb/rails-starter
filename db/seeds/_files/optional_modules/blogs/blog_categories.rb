# frozen_string_literal: true

#
# == Blog categories
#
puts 'Creating Blog categories'
@blog_category = BlogCategory.new(
  name: 'Non Categorisé',
  slug: 'non-categorise'
)
@blog_category.save(validate: false)

if @locales.include?(:en)
  bct = BlogCategory::Translation.create!(
    blog_category_id: @blog_category.id,
    locale: 'en',
    name: 'Uncategorized',
    slug: 'uncategorized'
  )
  bct.save(validate: false)
end
