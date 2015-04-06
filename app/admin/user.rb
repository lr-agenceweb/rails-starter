ActiveAdmin.register User do
  permit_params :id,
                :username,
                :email,
                :password,
                :password_confirmation

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
    f.actions
  end
end
