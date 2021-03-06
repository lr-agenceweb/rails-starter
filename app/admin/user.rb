# frozen_string_literal: true
ActiveAdmin.register User do
  includes :role

  permit_params do
    params = [:id,
              :username,
              :slug,
              :email,
              :password,
              :avatar,
              :delete_avatar,
              :password_confirmation]

    params.push :role_id unless current_user.subscriber?
    params
  end

  decorate_with UserDecorator
  config.clear_sidebar_sections!

  batch_action :reset_cache, if: proc { can? :reset_cache, User } do |ids|
    User.find(ids).each(&:touch)
    redirect_back(fallback_location: admin_dashboard_path, notice: t('active_admin.batch_actions.reset_cache'))
  end

  batch_action :toggle_active, if: proc { can? :toggle_active, User } do |ids|
    toggle_active(ids)
  end

  index do
    selectable_column
    column :image_avatar
    column :username
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :status
    bool_column :account_active
    actions
  end

  show do
    arbre_cache(self, resource.cache_key) do
      columns do
        column do
          attributes_table do
            row :image_avatar
            row :email
            row :sign_in_count
            row :current_sign_in_at
            row :last_sign_in_at
            row :status
            bool_row :account_active
            row :created_at
            if resource == current_user && SocialProvider.allowed_to_use?
              row :link_to_facebook if SocialProvider.provider_by_name('facebook').enabled?
              row :link_to_twitter if SocialProvider.provider_by_name('twitter').enabled?
              row :link_to_google if SocialProvider.provider_by_name('google').enabled?
            end
          end
        end

        column do
          panel t('activerecord.models.post.other') do
            table_for resource.posts.last(5) do
              column t('activerecord.attributes.picture.picture'), :image
              column t('activerecord.attributes.post.title'), :title
              bool_column t('activerecord.attributes.post.online'), :online
            end
          end
        end
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs t('formtastic.titles.user_details') do
          f.input :username
          f.input :email
          unless f.object.from_omniauth?
            f.input :password
            f.input :password_confirmation
          end
        end
      end

      unless f.object.from_omniauth?
        column do
          f.inputs t('formtastic.titles.user_avatar_details') do
            f.input :avatar,
                    as: :file,
                    hint: f.object.avatar.exists? ? retina_image_tag(f.object, :avatar, :small) : gravatar_image_tag(f.object.email, alt: f.object.username, gravatar: { secure: true })

            if f.object.avatar?
              f.input :delete_avatar,
                      as: :boolean
            end
          end
        end # column
      end # unless
    end # columns

    if current_user_and_administrator?
      columns do
        column do
          render 'admin/roles/form', f: f
        end # column
      end # columns
    end # if

    f.actions
  end

  #
  # == Controller
  #
  controller do
    include Skippable

    def scoped_collection
      super.includes posts: [:translations]
    end

    def update
      if params[:user].present?
        params_user_role_id = params[:user][:role_id]

        if current_user.administrator? && (params_user_role_id.to_i == Role.find_by(name: 'super_administrator').id)
          params[:user][:role_id] = current_user.role_id
        end

        params[:user][:role_id] = current_user.role_id unless Role.exists?(params_user_role_id)
      end

      super { admin_user_path(@user) }
    end

    def update_resource(resource, attributes)
      update_method = attributes.first[:password].present? ? :update_attributes : :update_without_password
      resource.send(update_method, *attributes)
    end

    private

    def toggle_active(ids)
      User.find(ids).each do |user|
        next if user == current_user || user.super_administrator?
        user.toggle! :account_active
        ActiveUserJob.set(wait: 3.seconds).perform_later(user) if user.account_active?
      end
      redirect_back(fallback_location: admin_dashboard_path, notice: t('active_admin.batch_actions.toggle_active'))
    end
  end
end
