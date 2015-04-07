ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel 'Utilisateurs' do
          table_for User.last(5) do
            column :avatar do |user|
              retina_image_tag(user, :avatar, :thumb)
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
            column :show_map do |resource|
              status_tag("#{resource.show_map}", (resource.show_map? ? :ok : :warn))
            end
            column('Actions') do |resource|
              link_to(I18n.t('active_admin.edit'), edit_admin_setting_path(resource)) + ' ' + link_to('Voir', admin_setting_path(resource))
            end
          end
        end
      end # column
    end # columns
  end # content
end
