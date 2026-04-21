# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "wf/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "petri_flow"
  spec.version     = Wf::VERSION
  spec.authors     = ["Hooopo Wang"]
  spec.email       = ["hoooopo@gmail.com"]
  spec.homepage    = "https://github.com/hooopo/petri_flow"
  spec.summary     = "Petri Net Workflow Engine for Ruby."
  spec.description = "Petri Net Workflow Engine for Ruby."
  spec.license     = "MIT"
  spec.required_ruby_version = ">= 4.0"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "bootstrap", "~> 5.3"
  spec.add_dependency "jquery-rails"
  spec.add_dependency "kaminari"
  spec.add_dependency "loaf"
  spec.add_dependency "mini_racer", "~> 0.20.0"
  spec.add_dependency "pg"
  spec.add_dependency "rails", ">= 8.0", "< 9.0"
  spec.add_dependency "rgl", "~> 0.6.6"
  spec.add_dependency "ruby-graphviz"
  spec.add_dependency "sassc-rails"
  spec.add_dependency "select2-rails-2020"
  spec.add_dependency "simple_command"
end
