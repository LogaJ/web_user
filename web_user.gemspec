# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "web_user/version"

Gem::Specification.new do |s|
  s.name        = "web_user"
  s.version     = WebUser::VERSION
  s.authors     = ["loga jegede"]
  s.email       = ["loga.jegede@net-a-porter.com"]
  s.homepage    = "http://gitosis.net-a-porter.com/cgit/test_web_user"
  s.summary     = 'a place to manage the task for the webuser role'
  s.description = 'a place to manage the task for the webuser role'

  s.rubyforge_project = "web_user"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rspec', '2.6.0'
  s.add_development_dependency 'simplecov', '>=0.4.0'

  s.add_runtime_dependency 'watir-webdriver', '0.2.9'
end
