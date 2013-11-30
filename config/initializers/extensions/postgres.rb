module ActiveRecord
  module ConnectionAdapters
    class PostgreSQLColumn < Column
      module Cast
        private

          def quote_and_escape(value)
            case value
            when "NULL"
              value
            else
              "\"#{value.gsub(/(["\\])/, '\\\\\1')}\""
            end
          end
      end
    end
  end
end
