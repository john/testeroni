namespace :db do
  desc 'drop, create, migrate db'
  task :reset => :environment do
    Rake::Task['db:drop'].execute
    puts 'dropped db'
    Rake::Task['db:create'].execute
    puts 'recreated db'
    Rake::Task['db:migrate'].execute
  end
end