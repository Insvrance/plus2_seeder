module Plus2Seeder
  class Conductor
    # Require all of the seeders
    Dir[File.expand_path('lib/seeder/seeders/*.rb')].each { |file| require file }

    @recorded = []


    def self.seeders=(val)
      @seeders = val
    end

    def self.seeders
      @seeders
    end

    def self.all_seeders
      @seeders.values.flatten.uniq
    end


    def self.record(seeder_name)
      @recorded << seeder_name
    end


    # Runs a named seeder
    def self.run(seeder_name)
      return if @recorded.include? seeder_name

      klass = "#{seeder_name}_seeder".classify.constantize
      seeder = klass.new

      seeder.run_dependencies

      seeder.reset if reset? # Call the seeder's reset method if called with RESET=true

      seeder.before

      puts "Seeding #{seeder_name.pluralize}"
      seeder.seed

      record seeder_name

      seeder.after
    end


    # Will run all seeders
    def seed
      self.class.seeders[Rails.env].each do |seeder|
        self.class.run(seeder)
      end
    end


    def self.reset?
      @reset ||= (ENV['RESET'] == 'true')
    end

  end
end

