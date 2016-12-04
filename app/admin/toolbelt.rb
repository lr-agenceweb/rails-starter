# frozen_string_literal: true
ActiveAdmin.register_page 'ToolBelt' do
  menu parent: I18n.t('admin_menu.config')

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
              row t('toolbelt.rails_server_name') do
                server_name
              end
              row t('toolbelt.deployed_branch') do
                branch_name
              end
              row t('toolbelt.delayed_job') do
                delayed_job_running?
              end
            end
          end
        end # panel
      end # column
    end # columns
  end # content
end
