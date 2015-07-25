ActiveAdmin.register User do
  includes :role

  permit_params :id,
                :username,
                :slug,
                :email,
                :password,
                :avatar,
                :delete_avatar,
                :password_confirmation,
                :role_id

  decorate_with UserDecorator
  config.clear_sidebar_sections!

  index do
    column :image_avatar
    column :username
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :status
    actions
  end

  show do
    columns do
      column do
        attributes_table do
          row :image_avatar
          row :email
          row :sign_in_count
          row :current_sign_in_at
          row :last_sign_in_at
          row :status
          row :created_at
        end
      end

      column do
        panel t('activerecord.models.post.other') do
          table_for resource.posts do
            column :image
            column :title
            column :status
          end
        end
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs 'User Details' do
          f.input :username
          f.input :email
          f.input :password
          f.input :password_confirmation
        end
      end

      column do
        f.inputs 'Avatar' do
          f.input :avatar,
                  as: :file,
                  hint: f.object.avatar.exists? ? retina_image_tag(f.object, :avatar, :small) : gravatar_image_tag(f.object.email, alt: f.object.username)

          if f.object.avatar?
            f.input :delete_avatar,
                    as: :boolean,
                    hint: 'Si coché, l\'avatar sera supprimé après mise à jour du profil et l\'image de gravatar sera utilisée'
          end
        end
      end

      if current_user_and_administrator?
        column do
          render 'admin/shared/roles/form', f: f
        end
      end
    end

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
