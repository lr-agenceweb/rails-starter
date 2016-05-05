class AddTranslationForBlogCategory < ActiveRecord::Migration
  def up
    BlogCategory.create_translation_table!({
      name: :string,
      slug: :string
    }, {
      migrate_data: true
    })
  end

  def down
    BlogCategory.drop_translation_table!
  end
end
