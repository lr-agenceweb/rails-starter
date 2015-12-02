class ChangePostcodeTypeToLocation < ActiveRecord::Migration
  def change
    change_column :locations, :postcode, :string
  end
end
