# frozen_string_literal: true
ActiveAdmin.register_page 'ToolBelt' do
  menu parent: I18n.t('admin_menu.config'),
       if: proc { current_user.super_administrator? }

  content do
    columns do
      column do
        div class: 'panel' do
          h3 t('toolbelt.application_settings_title')
          div class: 'panel_contents' do
            attributes_table_for false do
              row t('toolbelt.environment') do
                Rails.env
              end
              row t('toolbelt.rails_version') do
                Rails.version
              end
              row t('toolbelt.ruby_version') do
                RUBY_VERSION
              end
              row t('toolbelt.active_admin_version') do
                ActiveAdmin::VERSION
              end
            end
          end
        end # panel
      end # column

      column do
        div class: 'panel' do
          h3 t('toolbelt.server_settings_title')
          div class: 'panel_contents' do
            attributes_table_for false do
              row t('toolbelt.os_name') do
                `lsb_release -d`
              end
              row t('toolbelt.rails_server_name') do
                server_name
              end
              row t('toolbelt.deployed_branch') do
                branch_name
              end
              row t('toolbelt.delayed_job') do
                status_tag delayed_job_running?
              end
            end
          end
        end # panel
      end # column
    end # columns
  end # content

  controller do
    before_action :redirect_to_dashboard,
                  unless: proc { current_user.super_administrator? }

    def redirect_to_dashboard
      redirect_to admin_dashboard_path, status: 301
    end
  end
end
