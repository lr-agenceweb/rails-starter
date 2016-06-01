# frozen_string_literal: true

#
# == AdminBarHelper
#
module AdminBarHelper
  def morning_or_evening
    case Time.zone.now.hour
    when 6..12
      t('time.greeting.morning')
    when 13..17
      t('time.greeting.afternoon')
    else
      t('time.greeting.evening')
    end
  end
end
