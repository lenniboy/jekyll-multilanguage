# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll-multilanguage/version'

Gem::Specification.new do |gem|
  gem.name          = "jekyll-multilanguage"
  gem.version       = Jekyll::Multilanguage::VERSION
  gem.authors       = ["Leonard Ehrenfried"]
  gem.email         = ["leonard.ehrenfried@gmail.com"]
  gem.description   = %q{Add multi-language capabilties to Jekyll}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('jekyll', '~> 0.12.0')

  gem.add_development_dependency('rspec', '~> 2.13.0')
end
