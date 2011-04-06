# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "lincoln/version"

Gem::Specification.new do |s|
  s.name        = "lincoln"
  s.version     = Lincoln::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ben Curren"]
  s.email       = ["ben@outright.com"]
  s.homepage    = ""
  s.summary     = %q{Extensions to ActiveRecord to make it easier to run at scale.}
  s.description = %q{Extensions to ActiveRecord to make it easier to run at scale.}

  # s.rubyforge_project = "lincoln"
  
  s.required_ruby_version     = '>= 1.8.7'
  s.required_rubygems_version = ">= 1.3.6"
  
  s.add_dependency('activerecord', '~> 3.0')
  s.add_development_dependency "rspec", "~> 2.0"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
