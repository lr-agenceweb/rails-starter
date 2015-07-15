set :output, error: "#{path}/log/error.log", standard: "#{path}/log/cron.log"

every 1.day, at: '4:00 am' do
  rake '-s sitemap:refresh'
  rake 'db:backup MAX=10'
  command "backup perform -t #{Figaro.env.application_name}", environment: 'production'
end
