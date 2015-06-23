ActiveAdmin.register User do
  permit_params :id,
                :username,
                :email,
                :password,
                :avatar,
                :password_confirmation,
                :role_id

  config.clear_sidebar_sections!

  index do
    column :avatar do |resource|
      retina_thumb_square(resource)
    end
    column :username
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :role
    actions
  end

  show do
    h3 resource.username
    attributes_table do
      row :avatar do
        retina_image_tag(resource, :avatar, :medium)
      end
      row :email
      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
      row :role
      row :created_at
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs 'Admin Details' do
      f.input :avatar,
              as: :file,
              image_preview: true
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
      params_user = params[:user]
      params_user_role_id = params_user[:role_id]
      params_user.delete :role_id if current_user.subscriber?

      if current_user.administrator? && (params_user_role_id.to_i == Role.find_by(name: 'super_administrator').id)
        params[:user][:role_id] = current_user.role_id
      end

      params[:user][:role_id] = current_user.role_id unless Role.exists?(params_user_role_id)

      update! { admin_user_path(@user) }
    end

    def update_resource(object, attributes)
      update_method = attributes.first[:password].present? ? :update_attributes : :update_without_password
      object.send(update_method, *attributes)
    end
  end
end
