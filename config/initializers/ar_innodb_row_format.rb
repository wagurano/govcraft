ActiveSupport.on_load :active_record do
  module InnodbUtf8mb4
    def create_table(table_name, options = {})
      puts "Ignore 'options' in #create_table_with_innodb_row_format's options" if options.symbolize_keys![:options].present?
      table_options = options.reverse_merge(
        options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC',
      )

      method(:create_table).super_method.call(table_name, table_options) do |td|
       yield td if block_given?
      end
    end
  end

  module ActiveRecord::ConnectionAdapters
    class AbstractMysqlAdapter
      prepend InnodbUtf8mb4
    end
  end
end
