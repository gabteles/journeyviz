# Journeyviz

Journeyviz is a journey visualization gem. It defines journey as code so it can be versioned together with changes.

When defined, you can view your journey through a [rack](https://github.com/rack/rack) application.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'journeyviz'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install journeyviz

## Usage


### Defining the journey

Start by defining a journey. It is consisted of for elements: blocks, screens, actions and transitions.

Let's start from screens:

```ruby
# This is the journey definition block
Journeyviz.configure do |journey|
  # Here we're defining a screen called landing page
  journey.screen :landing_page
end
```

Now supose our landing page has a share button and we'd like to include it into our journey. We should define an action to represent it.

```ruby
Journeyviz.configure do |journey|
  journey.screen :landing_page do |landing|
    # Landing has an action called :share
    landing.action :share
  end
end
```

Imagine that the landing page also has an login form that sends the user to a logged-in area, into a dashboard page. Now we're going to use blocks and transitions.

```ruby
Journeyviz.configure do |journey|
  journey.screen :landing_page do |landing|
    landing.action :share
    # Define an action `login` that transitions the user to dashboard page
    # %i[logged dashboard] is the path to that screen. It includes every
    # block and finally the screen name.
    landing.action :login, transition: %i[logged dashboard]
  end

  # Defining the logged area
  journey.block :logged do |logged_area|
    # Dashboard inside logged area
    logged_area.screen :dashboard

    # Blocks can have blocks, you can call `logged_area.block :sublock` how many
    # times you want.
  end
end
```

### Visualizing journey

With journey definition loaded, you just have to mount the journeyviz server into your
rack application with `mount` command:

```ruby
mount Journeyviz::Server => '/journeyviz'
```

No just go to `/journeyviz` path on your application!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gabteles/journeyviz.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
