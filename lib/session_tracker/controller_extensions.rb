require File.join(File.dirname(__FILE__), 'controller_extensions', 'generators')

module SessionTracker
  module ControllerExtensions
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
  
      def track(*args)
        opts = args.extract_options!
        
        subject_method = opts[:subject_method] || SessionTracker::config[:default_subject_method]

        generator =  SessionTracker::Dsl::Generators::FilterLambda.new(subject_method)

        generator.track(args, opts)

        generator.install_on(self, opts)
      end

      alias tracks track

    end
  end
end
