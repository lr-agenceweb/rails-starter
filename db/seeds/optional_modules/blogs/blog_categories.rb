# frozen_string_literal: true

blog_categories_fr = [{
  name: 'Non Catégorisé',
  slug: 'non-categorise'
}, {
  name: 'Films',
  slug: 'films'
}, {
  name: 'Pokémon',
  slug: 'pokemon'
}]

blog_categories_en = [{
  name: 'Uncategorized',
  slug: 'uncategorized'
}, {
  name: 'Movies',
  slug: 'movies'
}, {
  name: 'Pokémon',
  slug: 'pokemon'
}]

#
# == Blog categories
#
puts 'Creating Blog categories'
blog_categories_fr.each_with_index do |item, index|
  @blog_category = BlogCategory.new(
    name: item[:name],
    slug: item[:slug]
  )
  @blog_category.save(validate: false)

  if @locales.include?(:en)
    bct = BlogCategory::Translation.create!(
      blog_category_id: @blog_category.id,
      locale: 'en',
      name: blog_categories_en[index][:name],
      slug: blog_categories_en[index][:slug]
    )
    bct.save(validate: false)
  end
end
