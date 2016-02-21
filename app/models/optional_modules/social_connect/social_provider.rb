# == Schema Information
#
# Table name: social_providers
#
#  id                        :integer          not null, primary key
#  name                      :string(255)
#  enabled                   :boolean          default(TRUE)
#  social_connect_setting_id :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# Indexes
#
#  index_social_providers_on_social_connect_setting_id  (social_connect_setting_id)
#

#
# == SocialProvider Model
#
class SocialProvider < ActiveRecord::Base
  belongs_to :social_connect_setting
end
