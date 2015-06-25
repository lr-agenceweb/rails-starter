#
# == HomeDecorator
#
class HomeDecorator < PostDecorator
  include Draper::LazyHelpers
  delegate_all
end
