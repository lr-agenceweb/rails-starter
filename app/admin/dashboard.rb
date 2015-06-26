ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    # Subscriber
    if current_user.subscriber?
      columns do
        column do |panel|
          render 'admin/dashboard/subscribers/posts', panel: panel, query: Post.includes(:translations).by_user(current_user.id).last(5)
        end

        column do |panel|
          render 'admin/dashboard/subscribers/comments', panel: panel
        end
      end # columns

      columns do
        column do |panel|
          render 'admin/dashboard/subscribers/user', panel: panel, query: User.includes(:role).find(current_user.id)
        end
      end # columns

    # Admin / SuperAdmin
    else
      columns do
        column do |panel|
          render 'admin/dashboard/subscribers/posts', panel: panel, query: Post.includes(:translations).last(5)
        end # column

        column do |panel|
          render 'admin/dashboard/subscribers/user', panel: panel, query: User.includes(:role).last(5)
        end
      end # columns

      columns do
        column do |panel|
          render 'admin/dashboard/settings', panel: panel, query: Setting.first
          render 'admin/dashboard/categories', panel: panel, query: Category.includes(:translations).visible_header.by_position
          render 'admin/dashboard/super_administrator/optional_modules', panel: panel, query: OptionalModule.all if current_user.super_administrator?
        end # column

        column do
          panel 'Mapbox' do
            render 'admin/settings/show', resource: Setting.first.decorate
          end
        end # column
      end # columns
    end # if / else
  end # content

  controller do
    before_action :set_setting

    private

    def set_setting
      @setting = Setting.first
      gon_params
    end
  end
end
