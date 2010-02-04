require File.join(File.dirname(__FILE__), 'model_extensions', 'for_subject')
require File.join(File.dirname(__FILE__), 'model_extensions', 'for_tracker')

module SessionTracker
  module ModelExtensions  #:nodoc:
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      # Add #has_role? and other role methods to the class.
      # Makes a class a auth. subject class.
      #
      # @param [Hash] options the options for tuning
      # @option options [String] :tracker_class_name (SessionTracker::config[:default_tracker_class_name])
      #                           Class name of the tracker class (e.g. 'ProgressTracker')
      # @option options [String] :association_name (SessionTracker::config[:default_association_name])
      #                           Association name (e.g. ':progress_tracker')
      # @example
      #   class User < ActiveRecord::Base
      #     acts_as_session_tracker_subject
      #   end
      #
      #   user = User.new
      #   user.tracker       #=> returns Tracker object
      #   user.track!(column_names, object)
      #
      def acts_as_session_tracker_subject(options = {})
      	assoc   = options[:association_name]   || SessionTracker::config[:default_association_name]
        tracker = options[:tracker_class_name] || SessionTracker::config[:default_tracker_class_name]

        has_one assoc, :class_name => tracker

        cattr_accessor :_tracker_class_name, :_subject_class_name,
                       :_tracker_assoc_name

        self._tracker_class_name = tracker
        self._subject_class_name = self.to_s
        self._tracker_assoc_name = assoc

        include SessionTracker::ModelExtensions::ForSubject
      end

      # Make a class an auth role class.
      #
      # You'll probably never create or use objects of this class directly.
      # Various auth. subject and object methods will do that for you
      # internally.
      #
      # @param [Hash] options the options for tuning
      # @option options [String] :subject_class_name (SessionTracker::config[:default_subject_class_name])
      #                          Subject class name (e.g. 'User', or 'Account)
      #
      # @example
      #   class SessionTracker < ActiveRecord::Base
      #     acts_as_session_tracker
      #   end
      #
      def acts_as_session_tracker(options = {})
        subject = options[:subject_class_name] || SessionTracker::config[:default_subject_class_name]

        belongs_to subject.demodulize.tableize.to_sym,
          :class_name => subject
        
        include SessionTracker::ModelExtensions::ForTracker
      end
    end
  end
end
