#
# RAILS_ENV=환경이름 bundle exec bin/rails runner bin/utf8mb4/create_column_conversions.rb
#
db = ActiveRecord::Base.connection

puts '#!/bin/bash'
puts ""
puts ""
puts ""

db.tables.each do |table|
  column_conversions = []
  db.columns(table).each do |column|
    case column.sql_type
      when /([a-z])*text/i
        default = (column.default.blank?) ? '' : "DEFAULT '#{column.default}'"
        null = (column.null) ? '' : 'NOT NULL'
        column_conversions << "CHANGE \\`#{column.name}\\` \\`#{column.name}\\` #{column.sql_type.upcase} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci #{default} #{null}"
      when /varchar\(([0-9]+)\)/i
        sql_type = column.sql_type.upcase
        default = (column.default.blank?) ? '' : "DEFAULT '#{column.default}'"
        null = (column.null) ? '' : 'NOT NULL'
        column_conversions << "CHANGE \\`#{column.name}\\` \\`#{column.name}\\` #{sql_type} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci #{default} #{null}".strip
    end
  end

  puts "# #{table}"
  if column_conversions.empty?
    puts "# NO CONVERSIONS NECESSARY FOR #{table}"
  else
    column_conversions.each do |column_conversion|
      puts "echo \"ALTER TABLE #{table} #{column_conversion}\" | mysql -uroot #{db.current_database}"
    end
  end
  puts ""
end
