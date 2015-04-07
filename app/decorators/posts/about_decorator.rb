#
# == AboutDecorator
#
class AboutDecorator < PostDecorator
  include Draper::LazyHelpers
  delegate_all
end
