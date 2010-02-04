module SessionTracker
  module Dsl
    class Base
      attr_reader :actions

      def initialize(*args)
        @original_args = args
      end

      def track(*args)
        @actions = args[0]

        opts = args.extract_options!

        raise ArgumentError, "You must use the :with option to specify one or more columns" unless opts[:with]

        @with_columns = opts[:with].is_a?(Array) ? opts[:with] : [opts[:with]]
        @with_columns.map! { |name| name.to_s }

        @object_symbol = opts[:object]
      end

    end
  end
end
