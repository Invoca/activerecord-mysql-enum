# CHANGELOG for `activerecord-mysql-enum`

Inspired by [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

Note: this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.2.1] - Unreleased
### Fixed
- Fixed a bug where the gem would only work with `Rails` and not all `ActiveRecord` projects

## [2.2.0] - 2022-07-18
### Added
- Added support for Rails 6.1 and 7.0

## [2.1.0] - 2022-04-11
### Added
- Added ruby 3 support

### Removed
- Dropped support for Rails less than 5

## [2.0.0] - 2021-08-10
### Removed
- Dropped support for Rails less than 5

## [1.0.0] - 2020-09-16
### Added
- A Rspec test suit
- Dummy Rails app to be used by tests
- Test coverage reports via Coveralls/SimpleCov
- A coverage report badge to the README
- Unit tests being run on push with TravisCI
- Appraisal to test Rails 4.2, 5.2, and 6.0
- A dependency on the mysql2 gem

### Changed
- Existing tests to be run with Rspec

### Removed
- Support for the mysql gem
- Support for Rails < 4.2

## [0.1.4] - 2020-08-20
### Fixed
- Fixed bug in `mysql_adapter` where optional arguments being passed to `type_to_sql` would cause
  an unexpected error

## [0.1.3] - 2020-08-19
### Changed
- refactor mysql adapter

## [0.1.2] - 2020-08-18
### Changed
- fixed frozen string to reassign value instead of append

## [0.1.1] - 2020-08-18
### Added
- extended activerecord dependency to '>= 4.2', '< 7'

## [0.1.0] - 2020-08-17
### Added
- Backwards compatibility with Rails 4

### Changed
- Renamed the gem from `enum_column3` to `activerecord-mysql-enum`

[2.2.1]: https://github.com/Invoca/activerecord-mysql-enum/compare/v2.2.0...v2.2.1
[2.2.0]: https://github.com/Invoca/activerecord-mysql-enum/compare/v2.1.0...v2.2.0
[2.1.0]: https://github.com/Invoca/activerecord-mysql-enum/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/Invoca/activerecord-mysql-enum/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/Invoca/activerecord-mysql-enum/compare/v0.1.4...v1.0.0
[0.1.4]: https://github.com/Invoca/activerecord-mysql-enum/compare/v0.1.3...v0.1.4
[0.1.3]: https://github.com/Invoca/activerecord-mysql-enum/compare/v0.1.2...v0.1.3
[0.1.2]: https://github.com/Invoca/activerecord-mysql-enum/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/Invoca/activerecord-mysql-enum/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/Invoca/activerecord-mysql-enum/tree/v0.1.0
