require 'rubygems'
require 'yolo'

Yolo::Tasks::Ios::Build.new

namespace :gem do
  desc "Builds and then installs the gem"
  task :buildinstall do
    system 'gem build yolo.gemspec'
    system 'gem install yolo-0.0.0.gem'
  end
end
