Gem::Specification.new do |s|
  s.name        = 'yolo'
  s.version     = '1.2.6'
  s.date        = Date.today.to_s
  s.executables << 'yolo'
  s.summary     = "YOLO!"
  s.description = "yolo is a RubyGem which provides a Ruby interface to Continuous Integration build tools. yolo is currently geared towards the Xcode toolchain and iOS development."
  s.authors     = ["Alex Fish"]
  s.email       = 'alex@alexefish.com'
  s.files       = Dir['Rakefile', '{bin,lib,test,spec}/**/*', 'README*', 'LICENSE*'] & `git ls-files -z`.split("\0")
  s.homepage    = 'http://rubygems.org/gems/yolo'
  s.add_runtime_dependency "xcodebuild-rb", ["= 0.2.0"]
  s.add_runtime_dependency "ocunit2junit", ["= 1.2"]
  s.add_runtime_dependency "calabash-cucumber"
  s.add_runtime_dependency "redcarpet"
end
