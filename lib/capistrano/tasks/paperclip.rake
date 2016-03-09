namespace :paperclip do
  namespace :refresh do
    desc 'Refresh All Paperclip Styles (Must Specify \'CLASS\' parameter)'
    task :all do
      if ENV['CLASS']
        on roles(:app) do
          within release_path do
            with rails_env: fetch(:rails_env) do
              execute :rake, "paperclip:refresh CLASS=#{ENV['CLASS']}"
            end
          end
        end
      else
        puts "\n\nFailed! You need to specify the 'CLASS' parameter!",
             'Usage: cap <env> paperclip:refresh:all CLASS=YourClass'
      end
    end

    desc 'Refresh Missing Paperclip Styles'
    task :missing do
      on roles(:app) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, 'paperclip:refresh:missing_styles'
          end
        end
      end
    end
  end
end
