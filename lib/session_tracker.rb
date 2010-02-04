require File.join(File.dirname(__FILE__), 'session_tracker', 'config')

if defined? ActiveRecord::Base
  require File.join(File.dirname(__FILE__), 'session_tracker', 'model_extensions')

  ActiveRecord::Base.send(:include, SessionTracker::ModelExtensions)
end


if defined? ActionController::Base
  require File.join(File.dirname(__FILE__), 'session_tracker', 'controller_extensions')

  ActionController::Base.send(:include, SessionTracker::ControllerExtensions)
end
