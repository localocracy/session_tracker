module SessionTracker
  module ModelExtensions
    module ForSubject
      
      def track!(columns, object = nil)
        self.tracker ||= Tracker.new
        self.tracker.track!(columns, object)
      end

    end
  end   
end
