require 'rubygems'
require 'yolo'

namespace :gem do
  desc "Builds and then installs the gem"
  task :buildinstall do
    system 'gem build yolo.gemspec'
    system 'gem install yolo-1.0.1.pre.gem'
  end
end
