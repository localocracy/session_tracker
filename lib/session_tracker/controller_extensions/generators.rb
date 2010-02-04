require File.join(File.dirname(__FILE__), 'dsl_base')

module SessionTracker

  class FilterSyntaxError < StandardError; end

  module Dsl
    module Generators
      class BaseGenerator < SessionTracker::Dsl::Base
        def initialize(*args)
          @subject_method = args[0]

          super
        end

        protected

        def _track_action
          "#{_subject_ref}.send(:track!, @with_columns, #{_object_ref})" 
        end

        def _subject_ref
          "#{_controller_ref}send(:#{@subject_method})"
        end

        def _object_ref
          return "#{nil}" unless @object_symbol
          "#{_controller_ref}instance_variable_get('@#{@object_symbol}')"
        end
        
        # is the object valid?
        def _object_valid
          return "#{true}" unless @object_symbol
          "#{_object_ref}.send(:valid?)"
        end

        def _action_ref
          "#{_controller_ref}action_name"
        end

        def _method_ref(method)
          "#{_controller_ref}send(:#{method})"
        end

        def _controller_ref
          @controller ? "#{@controller}." : ''
        end

        def install_on(controller_class, options)
          debug_dump(controller_class) if options[:debug]
        end

        def debug_dump(klass)
          return unless logger
          logger.debug "=== SessionTracker session_tracker dump (#{klass.to_s})"
          logger.debug self.to_s
          logger.debug "======"
        end

        def logger
          ActionController::Base.logger
        end
      end

      class FilterLambda < BaseGenerator
        def initialize(subject_method)
          super

          @controller = 'controller'
        end

        def install_on(controller_class, options)
          super
          options[:only] = @actions
          controller_class.send(:after_filter, options, &self.to_proc)
        end

        def to_proc
          code = <<-RUBY
            lambda do |controller|
              if #{_subject_ref} && #{_object_valid}
                #{_track_action}
              end
            end
          RUBY

          self.instance_eval(code, __FILE__, __LINE__)
        rescue SyntaxError
          raise FilterSyntaxError, code
        end
      end

    end
  end
end
