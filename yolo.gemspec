Gem::Specification.new do |s|
  s.name        = 'yolo'
  s.version     = '1.0.0.pre'
  s.date        = '2013-01-18'
  s.summary     = "YOLO!"
  s.description = "TBD..."
  s.authors     = ["Alex Fish"]
  s.email       = 'alex@alexefish.com'
  s.files       = ["lib/yolo.rb",
    "lib/yolo/tasks.rb",
    "lib/yolo/tools.rb",
    "lib/yolo/tasks/ios/build.rb",
    "lib/yolo/tasks/ios/release.rb",
    "lib/yolo/tasks/ios/ocunit.rb",
    "lib/yolo/tasks/ios/calabash.rb",
    "lib/yolo/tools/ios/calabash.rb",
    "lib/yolo/tools/ios/xcode.rb",
    "lib/yolo/tools/ios/ipa.rb",
    "lib/yolo/tools/ios/release_notes.rb",
    "lib/yolo/formatters.rb",
    "lib/yolo/formatters/progress_formatter.rb",
    "lib/yolo/formatters/error_formatter.rb"]
  s.homepage    = 'http://rubygems.org/gems/yolo'
  s.add_runtime_dependency "xcodebuild-rb", ["= 0.2.0"]
  s.add_runtime_dependency "ocunit2junit", ["= 1.2"]
  s.add_runtime_dependency "activerecord"
  s.add_runtime_dependency "calabash-cucumber"
end
