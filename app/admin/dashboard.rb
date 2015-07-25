ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    # Subscriber
    if current_user.subscriber?
      columns do
        column do |panel|
          render 'admin/dashboard/subscribers/posts', panel: panel, query: Post.includes(:translations).by_user(current_user.id).order(id: :desc).last(5)
        end

        if OptionalModule.find_by(name: 'Comment').enabled?
          column do |panel|
            render 'admin/dashboard/subscribers/comments', panel: panel, query: Comment.by_user(current_user.id).last(5)
          end
        end
      end # columns

      columns do
        column do |panel|
          render 'admin/dashboard/subscribers/user', panel: panel, query: [User.includes(:role).find(current_user.id)]
        end
      end # columns

    # Admin / SuperAdmin
    else
      columns do
        column do |panel|
          render 'admin/dashboard/subscribers/posts', panel: panel, query: Post.includes(:translations).order(id: :desc).last(5)
        end # column

        if OptionalModule.find_by(name: 'Comment').enabled?
          column do |panel|
            render 'admin/dashboard/subscribers/comments', panel: panel, query: Comment.order(id: :desc).last(5)
          end
        end
      end # columns

      columns do
        if current_user.super_administrator?
          column do |panel|
            render 'admin/dashboard/super_administrator/optional_modules', panel: panel, query: OptionalModule.all
          end
        end

        column do |panel|
          query = User.includes(:role).order(id: :desc).last(5) unless current_user.administrator?
          query = User.includes(:role).except_super_administrator.order(id: :desc).last(5) if current_user.administrator?
          render 'admin/dashboard/subscribers/user', panel: panel, query: query
        end
      end

      columns do
        column do |panel|
          render 'admin/dashboard/settings', panel: panel, query: Setting.first
          render 'admin/dashboard/categories', panel: panel, query: Category.includes(:background, :translations).by_position
        end # column

        if OptionalModule.find_by(name: 'Map').enabled?
          column do
            panel 'Mapbox' do
              Map.first.decorate.map(true, true)
            end
          end # column
        end # if / else
      end # columns
    end # if / else
  end # content

  controller do
    before_action :set_setting

    private

    def set_setting
      @setting = Setting.first
      @map = Map.first
      mapbox_gon_params
    end
  end
end
