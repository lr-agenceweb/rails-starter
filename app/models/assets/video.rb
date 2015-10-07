#
# == Video Model
#
class Video < ActiveRecord::Base
  belongs_to :videoable, polymorphic: true
end
