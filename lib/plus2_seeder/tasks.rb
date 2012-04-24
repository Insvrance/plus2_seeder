namespace :db do
  desc "Recreate the database from migrations and re-seed"
  task :recreate => [:drop, :create, :migrate, :seed]

  namespace :seed do
    Plus2Seeder::Conductor.all_seeders.each do |seeder|
      name = seeder.pluralize

      desc "Seed #{name}"
      task name => :environment do
        Plus2Seeder::Conductor.run(seeder)
      end
    end
  end
end

