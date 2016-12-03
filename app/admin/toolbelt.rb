# frozen_string_literal: true
ActiveAdmin.register_page 'ToolBelt' do
  menu parent: I18n.t('admin_menu.config')

  content do
    columns do
      column do
        div class: 'panel' do
          h3 'Caractéristiques de l\'application'
          div class: 'panel_contents' do
            attributes_table_for false do
              row 'Environment' do
                Rails.env
              end
              row 'Rails version' do
                Rails.version
              end
              row 'Ruby version' do
                RUBY_VERSION
              end
              row 'ActiveAdmin version' do
                ActiveAdmin::VERSION
              end
            end
          end
        end # panel
      end # column

      column do
        div class: 'panel' do
          h3 'Caractéristiques du serveur'
          div class: 'panel_contents' do
            attributes_table_for false do
              row 'Server name' do
                server_name
              end
              row 'Deployed branch' do
                branch_name
              end
              row 'DelayedJob' do
                delayed_job_running?
              end
            end
          end
        end # panel
      end # column
    end # columns
  end # content
end
