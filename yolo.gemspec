Gem::Specification.new do |s|
  s.name        = 'yolo'
  s.version     = '1.0.0.pre'
  s.date        = Date.today.to_s
  s.summary     = "YOLO!"
  s.description = "TBD..."
  s.authors     = ["Alex Fish"]
  s.email       = 'alex@alexefish.com'
  s.files        = Dir['Rakefile', '{bin,lib,test,spec}/**/*', 'README*', 'LICENSE*'] & `git ls-files -z`.split("\0")
  s.homepage    = 'http://rubygems.org/gems/yolo'
  s.add_runtime_dependency "xcodebuild-rb", ["= 0.2.0"]
  s.add_runtime_dependency "ocunit2junit", ["= 1.2"]
  s.add_runtime_dependency "calabash-cucumber"
end
