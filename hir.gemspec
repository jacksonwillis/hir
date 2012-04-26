#!/usr/bin/env ruby

Gem::Specification.new do |gem|
  gem.name          = "hir"
  gem.version       = "1.0.2"
  gem.files         = ["lib/hir.rb"]

  gem.required_ruby_version = ">= 1.8.7"
  gem.add_development_dependency("rspec", "~> 0.9")

  gem.description   = "hir: HTML in Ruby"
  gem.summary       = "Write HTML as Ruby blocks"

  gem.authors       = ["Jack Willis"]
  gem.email         = ["jcwillis.school@gmail.com"]
  gem.homepage      = "http://github.com/jacksonwillis/hir"
end
