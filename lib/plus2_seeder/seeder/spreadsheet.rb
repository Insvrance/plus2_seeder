# Superclass to be used for seeders that import data from a spreadsheet.
# The subclass needs to specify the source file, sheet, and column names.
# The subclass can optionally implement a pre_process and can_import? method. 
#
# e.g.
#
#   class PersonSeeder < SpreadsheetSeeder
#     source 'people.xls' 
#     sheet  'People'
#     columns %w(name email phone)
#   end
#
#   PersonSeeder.new.seed
#
#   Will create instances of Person from the data in the People sheet of db/seeds/people.xls.
module Plus2Seeder
  module Seeder

    class Spreadsheet < Base

      # Used to specify the spreadsheet to import. Assumed to be in db/seeds
      def self.source(*filenames)
        @filenames ||= filenames
      end


      # The sheet name to import from
      def self.sheet(sheetname=nil)
        @sheetname ||= sheetname
      end


      # The names of the columns - use the active record attribute names.
      # These will be zipped up with the row values by row_to_hash to create an attributes hash that
      # can be used to create a new ActiveRecord instance.
      #
      # To skip a column use '_', it will be deleted from the resulting hash
      def self.columns(columns=nil)
        @columns ||= columns
      end


      # Skip (n) rows before starting to import
      def self.skip_rows(rows=nil)
        @skip_rows ||= rows || 0
      end


      # Opens the spreadsheet and calls import for each row
      def seed
        self.class.source.each do |source|
          book = ::Spreadsheet.open "./db/seeds/#{source}"

          sheet = book.worksheet self.class.sheet

          sheet.each self.class.skip_rows do |row|
            import(row_to_hash(row))
          end
        end
      end


      # Creates a hash from the row values and column names
      def row_to_hash(row)
        Hash[self.class.columns.zip(row)].tap do |h|
          pre_process(h, row) if respond_to?(:pre_process)

          # Delete skipped columns
          h.delete('_')
        end
      end


      # Imports the row
      def import(row)
        if can_import?(row)
          if object = object_available_to_update(row)
            debug("Updating #{object}")
            object.update_attributes(row)
          else
            debug("Creating new #{creator_class.name}")
            creator_class.create!(row)
          end
        end
      end


      # Determines whether or not the row can be imported. Override this in your subclass if desired
      def can_import?(row)
        true
      end


      # Override this in your subclass if you wish to update existing data from your seeder. It will need to return
      # an instance of the AR object to be updated
      def object_available_to_update(row)
        nil
      end

    end

  end
end
