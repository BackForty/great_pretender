[![Code Climate](https://codeclimate.com/github/BackForty/great_pretender/badges/gpa.svg)](https://codeclimate.com/github/BackForty/great_pretender) [![Test Coverage](https://codeclimate.com/github/BackForty/great_pretender/badges/coverage.svg)](https://codeclimate.com/github/BackForty/great_pretender)

# Great Pretender

**Ridiculously easy-to-use Rails mockups for those enlightened individuals who design in-browser.**

## Features

**Great Pretender** was designed to be easy and awesome. Here are a few of its neat features:

- Allows for easy stubbing with test data
- Supports multiple layouts
- Supports nested mockup directories (e.g. `app/views/mockups/users/sessions/whatever.html.slim`)
- Supports partials
- Installs in 2 minutes as a Rails engine
- Can be mixed in to other controllers for access control or whatever else you want to add
- Configurable mockups folder name and default layout

## Install

Just add it to your Gemfile and go!

1. Add it to your `Gemfile`

	```ruby
	group :development do
	  gem 'great_pretender'
	end
	```

2. Bundle

		bundle install

## Configuration

You can override two things in Great Pretender:

1. The mockups folder name (default is `mockups`, as in `app/views/mockups`)
2. The default layout to render mockups within (default is `application`, as in the one you normally use)

You can add `config/initializers/great_pretender.rb` and configure it to your liking:

```ruby
if defined? GreatPretender
  GreatPretender.config do |c|
    c.default_layout = "public_facing"
    c.view_path = "wireframes"
  end
end
```

## Getting Started

### With the Rails engine

If you're just using Great Pretender to pass mockups from designer to developer, you can get started really easily by adding it to  `config/routes.rb`:

```ruby
Rails.application.routes.draw do
  mount GreatPretender::Engine, at: 'mockups' if defined?(GreatPretender)
end
```

Take care to load it only in the environments you want. Typically I've seen just the development environment, but I also know people who use mockups on staging to show remote clients.

### With your own controller

Some people want to have a little bit more control over their mockups (in order to, for example, require an admin account to view them on a staging server).

If that's the case, you can create your own controller that uses Great Pretender:

1. Create a controller that uses whatever inheritance you're interested in, and mix `GreatPretender::Controller` into it:

	```ruby
	class Admin::MockupsController < Admin::ApplicationController
	  include GreatPretender::Controller

	  before_action :require_admin_user! # or whatever
	  layout 'admin' # or whatever
	end
	```

2. Manually add routes to the Great Pretender actions (`index` and `show`). **Please note** that the `show` action requires a `*splat`-style id:

	```ruby
	Rails.application.routes.draw do
	  namespace :admin do
	    # ... your other stuff ...
	    get 'mockups', to: 'mockups#index', as: :mockups
	    get 'mockups/*id', to: 'mockups#show', as: :mockup
	  end
	end
	```

3. **(OPTIONAL)** Override the `great_pretender/index.html` template to render it in your custom interface.

	Available helper methods are `mockups` (an array of `GreatPretender::Mockup` objects) and `mockup_root` (the path where you should add mockups).

	Here's an example:

	```haml
	%ul
	  - mockups.each do |mockup|
	    %li= link_to mockup.name, admin_mockup_path(mockup)
	```

## Creating Mockups

Once you've got Great Pretender up and running, you should add some mockups. By default, you would put these in `app/views/mockups`, but if you overrode `view_path` in `GreatPretender.config.view_path`, you would use `app/views/whatever_you_overrode_it_to`.

1. Add a mockup file

	For example, in `app/views/mockups/users/show.html.slim`:

	```slim
	header= image_tag "logo.png"
	p
	  | I can use regular Rails helpers because this is just a template file!
	  ' Hooray!
	```

2. Open your browser and navigate to whatever path you installed Great Pretender on (90% of cases I'm guessing will be at [http://localhost:3000/mockups](http://localhost:3000/mockups)). Then click on your mockup.

3. Profit

### Partials

You can add partials like you would anywhere else. Just prefix them with a skid (`_`) and go from there.

By default, partials render **without a layout**, so you can request them using AJAX and receive the HTML free of all that layout cruft.

If you *want* to receive a layout as part of it, use a custom layout (see next section) and just request that mockups' path.

### Multiple layout support

If you're designing for a site with multiple layouts, you can simply nest mockup files in a folder with the name of a layout, and they'll be rendered with that layout. For example, with the following structure...

```
app/
|- views/
|--- layouts/
|----- application.html.slim
|----- admin.html.slim
|--- mockups/
|----- admin/
|------- index.html.slim
|------- users/
|--------- index.html.slim
```

...all of the mockups in `app/views/mockups/admin` would render using the `admin` layout.

Using this strategy, you can name your mockups clearly after their conceptual section in your app.

## Rendering With Test Data (Pretender Objects)

A lot of the time you'll want to emulate real data in your views. In those cases, Great Pretender supports the use of "Pretender" objects in `app/pretenders`.

Pretender objects can be any class. They can accept a single argument in `initialize`, which will be the the mockup being rendered, **or** they can skip it entirely.

An instance of every pretender will be available inside your templates. So for, e.g., a `user_pretender.rb` that defines:

```
class UserPretender
	def name
		"Gary Sinese"
	end
end
```

You would reference a `user` helper method (or `user_pretender` if `user` is already defined):

```erb
<%= user.name %> <!-- Outputs "Gary Sinese" -->
or
<%= user_pretender.name %> <!-- Outputs same -->
```

### Example

Here's an example using the excellent [Faker gem](https://github.com/stympy/faker) (I leave it to you to figure out how you want to generate test data, but Faker is pretty awesome).

#### `app/pretenders/user_pretender.rb`

```ruby
require "faker"

class UserPretender
  def login
    Faker::Internet.user_name
  end

  def email
    Faker::Internet.email
  end
end
```

#### `app/views/mockups/users/login.html.slim`


```slim
header
  | Welome back, #{user.login}!
  | Your email is set to #{user.email}

  / The remainder of your login form mockup...
```

## The end!

Thanks for using Great Pretender! I hope it helps you like it's helped us!

Copyright &copy; 2014 [Back Forty LLC](http://www.inthebackforty.com/)
