Gem::Specification.new do |s|
  s.name        = 'yolo'
  s.version     = '0.0.0'
  s.date        = '2013-01-18'
  s.summary     = "YOLO!"
  s.description = "TBD..."
  s.authors     = ["Alex Fish"]
  s.email       = 'alex@alexefihs.com'
  s.files       = ["lib/yolo.rb", "lib/yolo/tasks.rb", "lib/yolo/tasks/ios/build.rb"]
  s.homepage    = 'http://rubygems.org/gems/yolo'
  s.add_runtime_dependency "xcodebuild-rb", ["= 0.2.0"]
  s.add_runtime_dependency "ocunit2junit", ["= 1.2"]
end
