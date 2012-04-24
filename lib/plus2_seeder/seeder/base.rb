module Plus2Seeder

  module Seeder

    class Base

      # These seeders will be run before the subclass's seeder
      def self.dependencies(dependency_list=nil)
        @dependencies ||= dependency_list
      end


      def run(seeder_name)
        Plus2Seeder.run(seeder_name)
      end


      def run_dependencies
        if self.class.dependencies.try(:any?)
          self.class.dependencies.each do |seeder_name|
            run(seeder_name)
          end
        end
      end


      # Determines the model class to use based on the name of the seeder
      def creator_class
        @creator_class ||= self.class.name.gsub('Seeder', '').constantize
      end


      def reset
        puts "Clearing #{creator_class.table_name}"
        creator_class.delete_all
      end


      def before
        #override if you want to do something before seeding
      end


      def after
        #override if you want to do something after seeding
      end


      def debug?
        @debug ||= (ENV['DEBUG'] == 'true')
      end


      def debug(val)
        ap val if debug?
      end

    end

  end

end
