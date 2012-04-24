# -*- encoding: utf-8 -*-
require File.expand_path('../lib/plus2_seeder/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ben Askins"]
  gem.email         = ["ben.askins@gmail.com"]
  gem.description   = %q{database seeder}
  gem.summary       = %q{database seeder}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "plus2_seeder"
  gem.require_paths = ["lib"]
  gem.version       = Plus2Seeder::VERSION
end
