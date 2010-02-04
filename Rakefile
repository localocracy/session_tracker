require 'rubygems'
require 'rake'
require 'rake/testtask'

desc 'Default: run tests.'
task :default => :test

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "session_tracker"
    s.summary = "Simple tracking for user session goals"
    s.email = "aaron@localocracy.org"
    s.homepage = "http://github.com/localocracy/session_tracker"
    s.description = "Provides a simple DSL for keeping track of when a user visits certain actions."
    s.authors = ["Aaron Soules"]
    s.files = FileList["[A-Z]*", "{lib,test}/**/*.rb"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
end

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = false
end

begin
  require 'yard'

  YARD::Rake::YardocTask.new do |t|
    t.files   = ['lib/**/*.rb']
    #t.options = ['--any', '--extra', '--opts'] # optional
  end
rescue LoadError
end
