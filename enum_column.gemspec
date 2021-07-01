# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "active_record/mysql/enum/version"

Gem::Specification.new do |spec|
  spec.name          = "activerecord-mysql-enum"
  spec.version       = ActiveRecord::Mysql::Enum::VERSION
  spec.authors       = ["Nick Pohodnya", "Invoca Development"]
  spec.email         = ["development@invoca.com"]

  spec.summary     = "Enable enum type for the MySQL Adapter in ActiveRecord"
  spec.description = spec.summary
  spec.homepage    = "http://github.com/Invoca/activerecord-mysql-enum"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata    = {
    "source_code_uri"   => "https://github.com/Invoca/activerecord-mysql-enum",
    'allowed_push_host' => "https://rubygems.org"
  }

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  spec.add_dependency 'activerecord', '>= 4.2', '< 7'
  spec.add_dependency 'mysql2', '~> 0.4.5'
end
