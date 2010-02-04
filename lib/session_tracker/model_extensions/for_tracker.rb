module SessionTracker
  module ModelExtensions
    module ForTracker
      
      def track!(column_names, object = nil)
        raise ArgumentError, "track! takes an array of column names as the first argument" unless column_names.is_a?(Array)

        for column_name in column_names
          next unless self[column_name].blank? # skip column if already used

          case(self.class.columns_hash[column_name].type)
            when :integer  then self[column_name] = object.id
            when :datetime then self[column_name] = Time.now
          end
        end
        
        self.save! if self.changed?
      end
      
      def complete?
        self.class.column_names.all? { |name| !self[name].blank? }
      end

    end
  end   
end
