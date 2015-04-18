ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel 'Utilisateurs' do
          table_for User.includes(:role).last(5) do
            column :avatar do |user|
              retina_thumb_square(user)
            end
            column :username
            column :email
            column :role
            column('Actions') do |user|
              link_to('Voir', admin_user_path(user))
            end
          end
        end
      end # column

      column do
        panel 'Settings' do
          table_for Setting.first do
            column :title
            column :subtitle
            column :show_map

            column('Actions') do |resource|
              link_to(I18n.t('active_admin.edit'), edit_admin_setting_path(resource)) + ' ' + link_to('Voir', admin_setting_path(resource))
            end
          end
        end

        panel 'Categories' do
          table_for Category.includes(:translations).visible_header.by_position do
            column :position
            column :title
            column :show_in_menu
            column :show_in_footer
          end
        end
      end # column
    end # columns

    columns do
      column do
        panel 'Mapbox' do
          render 'admin/settings/show', resource: Setting.first.decorate
        end
      end # column
    end # columns
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
