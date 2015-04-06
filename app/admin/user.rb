ActiveAdmin.register User do
  permit_params :id,
                :username,
                :email,
                :password,
                :password_confirmation,
                role_attributes: [
                  :id, :name
                ]

  config.clear_sidebar_sections!

  index do
    column :username
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :role
    actions
  end

  form do |f|
    f.inputs 'Admin Details' do
      f.input :username
      f.input :email
      f.input :password
      f.input :password_confirmation
    end

    render 'admin/shared/roles/form', f: f if current_user_and_administrator?
    f.actions
  end

  #
  # == Controller
  #
  controller do
    def update
      update! { admin_users_path }
    end

    def update_resource(object, attributes)
      update_method = attributes.first[:password].present? ? :update_attributes : :update_without_password
      object.send(update_method, *attributes)
    end
  end
end
