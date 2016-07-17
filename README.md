# activerecord-postgresql-cube

Adds support to ActiveRecord for the PostgreSQL cube data type.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-postgresql-cube'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-postgresql-cube

## Usage

Make sure you have the cube extension enabled on your database, then add and index a column with a `cube` type:

```ruby
enable_extension "cube"
add_column :things, :features, :cube
add_index :things, :features, using: "gist"
```

Define optional accessor methods:

```ruby
class Thing < ActiveRecord::Base
  cube_attributes :features, :fluffiness, :crunchiness, :hotness, :dryness
end

# These are equivalent:
Thing.new(features: [1.0, 0.0, 0.5, 0.2])
Thing.new(fluffiness: 1.0, crunchiness: 0.0, hotness: 0.5, dryness: 0.2)
```

Query ordered by cube distance to find similar results.

```ruby
# Seed with some random values:
100.times { Thing.create(features: Array.new(4) { rand }) }

# Query directly:
my_favorite_thing = Thing.by_cube_distance(:features, [1.0, 0.0, 0.5, 0.2]).first
# => #<Thing id: 39, features: [0.832089176888876, 0.192166292526192, 0.56526526018018, 0.0925453162946783]>
my_favorite_thing.distance # => 0.284478455665301

# Or by distance from an existing record:
recommended_thing = my_favorite_thing.similar_by_cube_distance(:features).first
# => #<Thing id: 691, features: [0.61796879992257, 0.249908423662009, 0.593267501286819, 0.0877211312590144]>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/quadule/activerecord-postgresql-cube.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
