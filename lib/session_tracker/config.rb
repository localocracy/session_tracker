module SessionTracker
  @@config = {
    :default_tracker_class_name => 'Tracker',
    :default_subject_class_name => 'User',
    :default_subject_method => :current_user,
    :default_association_name => :tracker
  }
  
  mattr_reader :config
end
    
