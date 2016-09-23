class CreatePublicationDates < ActiveRecord::Migration
  def change
    create_table :publication_dates do |t|
      t.references :publishable, polymorphic: true, index: true
      t.boolean :published_later, default: false
      t.boolean :expired_prematurely, default: false
      t.datetime :published_at
      t.datetime :expired_at

      t.timestamps null: false
    end
  end
end
