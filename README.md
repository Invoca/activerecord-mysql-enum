# ActiveRecord::Mysql::Enum [![Coverage Status](https://coveralls.io/repos/github/Invoca/activerecord-mysql-enum/badge.svg?branch=master)](https://coveralls.io/github/Invoca/activerecord-mysql-enum?branch=master)

This gem is an extension to ActiveRecord which enables native support of
enumerations in the database schema using the ENUM type in MySQL. Forked
and revitalized from [enum_column3](https://github.com/jewlr/enum_column)
which was itself a fork of a fork of Nick Pohodnya's original gem for
Rails 3, [enum_column3](https://github.com/electronick/enum_column).

## Support
Currently this has been manually tested with Rails version 4 and 5, and works with scaffolding.

**Supported adapters:**
- mysql
- mysql2
- jdbcmysql (by Nilesh Trivedi)

## Installation
In your `Gemfile` add the following snippet
```ruby
gem 'activerecord-mysql-enum', '~> 0.1', require: 'active_record/mysql/enum'
```

## Usage
### Schema Definitions
When defining an enum in your schema, specify the constraint as a limit:
```ruby
create_table :enumerations, :force => true do |t|
  t.column :severity, :enum, :limit => [:low, :medium, :high, :critical], :default => :medium
  t.column :color, :enum, :limit => [:red, :blue, :green, :yellow]
end
```

### Model Validations
You can then automatically validate this column using:
```ruby
validates_columns :severity, :color
```

### Setting/Getting Values
All enumerated values will be given as symbols.
```ruby
@e = Enumeration.new
@e.severity = :medium
```

You can always use the column reflection to get the list of possible values from the database column.
```ruby
irb(1)> Enumeration.columns_hash['color'].limit
=> [:red, :blue, :green, :yellow]
irb(2)> @enumeration.column_for_attribute(:color).limit
=> [:red, :blue, :green, :yellow]
```
