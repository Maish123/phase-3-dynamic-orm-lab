require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord
    ## FOR THE TABLE NAME(CLASS NAME)
    def self.table_name
        self.to_s.downcase.pluralize
    end

    ## FOR THE COLUMN NAME(ATTRIBUTES OF THE INSTANCES)
    def self.column_names
        DB[:conn].results are hash = true
        sql = ("pragma table into ('#{table_name}')")
        table_info = DB[:conn].execute(sql)
        column_names = []
        table_info.each do|row|
            column_names-names << row["name"]
        end
        column_names.compact
    end

    ##THE SELF INITIALIZE METHOD
    def initialize(options={})
        options.each do|property, value|
            self.send("#{property}=", value)
        end
    end

    ##SAVE THE ROW
    def save
        sql = "INSERT INTO (#{table_name_for_insert}) (#{column_names_for_insert}) VALUES (#{values_for_insert})"
        DB[:conn].execute(sql)
        @id = DB[:con].execute("SELECT last_insert_rowid() FROM #{table_name_for_insert}")[0][0]
    end

    ##TO GET THE TABLE NAME FOR INSERT
    def table_name_for_insert
        self.class.table_name
    end

    ## TO GET THE VALUES FOR INSERT
    def values_for_insert
        values = []
        self.class.column_names.each do|col_name|
            values << "'#{send(col_name)}'" unless send(col_name).nil?
        end
        values.join(",")
    end

    ## TO GET THE COLUMN NAMES FOR INSERT
    def col_names_for_insert
        self.class.column_names.delete if{|col| col == "id"}.join(",")
    end

    def self.find_by_name(name)
        sql = "SELECT FROM #{self.table_name} WHERE name = '#{name}'"
        DB[:conn].execute(sql)
    end
  
end