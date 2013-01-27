require 'rubygems'
require 'yolo'

namespace :gem do
  desc "Builds and then installs the gem"
  task :buildinstall do
    system 'gem build yolo.gemspec'
    system 'gem install yolo-1.0.0.pre.gem'
  end
end

### Sample

#Yolo::Tasks::Ios::Build.new do |t|
#  t.workspace = "Honk.xcworkspace"
#  t.scheme = "Honk"
#  t.formatter = XcodeBuild::Formatters::ProgressFormatter.new
#end
#
#Yolo::Tasks::Ios::OCUnit.new do |t|
#  t.workspace = "Honk.xcworkspace"
#  t.scheme = "HonkTests"
#  t.test_output = :junit
#  t.formatter = XcodeBuild::Formatters::ProgressFormatter.new
#end
#
#Yolo::Tasks::Ios::Calabash.new do |t|
#  t.workspace = "Honk.xcworkspace"
#  t.scheme = "Honk-cal"
#  t.format = :junit
#  t.formatter = XcodeBuild::Formatters::ProgressFormatter.new
#end
