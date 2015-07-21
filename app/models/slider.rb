# == Schema Information
#
# Table name: sliders
#
#  id          :integer          not null, primary key
#  animate     :string(255)
#  autoplay    :boolean          default(TRUE)
#  timeout     :integer          default(5000)
#  hover_pause :boolean          default(TRUE)
#  loop        :boolean          default(TRUE)
#  navigation  :boolean          default(FALSE)
#  bullet      :boolean          default(FALSE)
#  category_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_sliders_on_category_id  (category_id)
#

class Slider < ActiveRecord::Base
end
