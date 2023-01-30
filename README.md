# page_meta

[![Tests](https://github.com/fnando/page_meta/workflows/ruby-tests/badge.svg)](https://github.com/fnando/page_meta)
[![Gem](https://img.shields.io/gem/v/page_meta.svg)](https://rubygems.org/gems/page_meta)
[![Gem](https://img.shields.io/gem/dt/page_meta.svg)](https://rubygems.org/gems/page_meta)

Easily define `<meta>` and `<link>` tags. I18n support for descriptions,
keywords and titles.

## Installation

```bash
gem install page_meta
```

Or add the following line to your project's Gemfile:

```ruby
gem "page_meta"
```

## Usage

Your controller and views have an object called `page_meta`. You can use it to
define meta tags and links. By default, it will include the encoding, language
and viewport meta tags.

```html
<meta charset="utf-8" />
<meta name="language" content="en" />
<meta itemprop="language" content="en" />
<meta name="viewport" content="width=device-width,initial-scale=1" />
```

You can use I18n to define titles, descriptions and keywords. These values will
be inferred from the controller and action names. For an action
`SiteController#index` you'll need the following translation scope:

```yaml
en:
  page_meta:
    title_base: "%{value} • MyApp"

    site:
      index:
        title: "Welcome to MyApp"
```

Previously, you could also use the `page_meta.{titles,description,keywords}` scopes, but this is now
deprecated in favor of the above.

```yaml
---
en:
  page_meta:
    titles:
      base: "%{value} • MyApp"
      site:
        index: "Welcome to MyApp"
```

The title without the `base` context can be accessed through
`page_meta.title.simple`.

```erb
<%= page_meta.title %>          // Welcome to MyApp • MyApp
<%= page_meta.title.simple %>   // Welcome to MyApp
```

Sometimes you need to render some dynamic value. In this case, you can use the
I18n placeholders.

```yaml
---
en:
  page_meta:
    title_base: "%{title} • MyCompany"

    workshops:
      show:
        title: "%{name}"
```

You can then set dynamic values using the `PageMeta::Base#[]=`.

```ruby
class WorkshopsController < ApplicationController
  def show
    @workshop = Workshop.find_by_permalink!(params[:permalink])
    page_meta[:name] = @workshop.name
  end
end
```

Some actions are aliased, so you don't have to duplicate the translations:

- Action `create` points to `new`
- Action `update` points to `edit`
- Action `destroy` points to `remove`

The same concept is applied to descriptions and keywords.

```yaml
---
en:
  page_meta:
    base_title: "%{value} • MyApp"
    site:
      show:
        title: "Show"
        description: MyApp is the best way of doing something.
        keywords: "myapp, thing, other thing"
```

### Defining meta tags

To define other meta tags, you have to use `PageMeta::Base#tag` like the
following:

```ruby
class Workshops Controller < ApplicationController
  def show
    @workshop = Workshop.find_by_permalink(params[:permalink])
    page_meta.tag :description, @workshop.description
    page_meta.tag :keywords, @workshop.tags
  end
end
```

You can define default meta/link tags in a `before_action`:

```ruby
class ApplicationController < ActionController::Base
  before_action :set_default_meta

  private

  def set_default_meta
    page_meta.tag :dns_prefetch_control, "http://example.com"
    page_meta.tag :robots, "index, follow"
    page_meta.tag :copyright, "Example Inc."
  end
end
```

Finally, you can define meta tags for Facebook and Twitter:

```ruby
# Meta tags for Facebook
page_meta.tag :og, {
  image: helpers.asset_url("fb.png"),
  image_type: "image/png",
  image_width: 800,
  image_height: 600,
  description: @workshop.description,
  title: @workshop.name,
  url: workshop_url(@workshop)
}

# Meta tags for Twitter
page_meta.tag :twitter, {
  card: "summary_large_image",
  title: @workshop.name,
  description: @workshop.description,
  site: "@howto",
  creator: "@fnando",
  image: helpers.asset_url(@workshop.cover_image)
}
```

### Defining link tags

To define link tags, you have to use `PageMeta::Base#link` like the following:

```ruby
page_meta.link :canonical, href: article_url(article)
page_meta.link :last, href: article_url(articles.last)
page_meta.link :first, href: article_url(articles.first)
```

The hash can be any of the link tag's attributes. The following example defines
the Safari 9 Pinned Tab icon:

```ruby
page_meta.link :mask_icon, color: "#4078c0", href: helpers.asset_url("mask_icon.svg")
```

### Rendering the elements

To render all tags, just do something like this:

```erb
<!DOCTYPE html>
<html lang="en">
  <head>
    <%= page_meta %>
  </head>
  <body>
    <%= yield %>
  </body>
</html>
```

#### Rendering titles and descriptions

You may want to render title and description on your page. In this case, you may
use something like this:

```erb
<h1><%= page_meta.title.simple %></h1>
<p><%= page_meta.description.simple %></p>
```

If your description contains HTML, you can use
`page_meta.description(html: true).simple` instead. It will use Rails'
`html_safe` helpers to safely retrieve the translation, just like regular Rails
would do.
[Please read Rails docs](http://guides.rubyonrails.org/i18n.html#using-safe-html-translations)
for more info.

## Maintainer

- [Nando Vieira](https://github.com/fnando)

## Contributors

- https://github.com/fnando/page_meta/contributors

## Contributing

For more details about how to contribute, please read
https://github.com/fnando/page_meta/blob/main/CONTRIBUTING.md.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT). A copy of the license can be
found at https://github.com/fnando/page_meta/blob/main/LICENSE.md.

## Code of Conduct

Everyone interacting in the page_meta project's codebases, issue trackers, chat
rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/fnando/page_meta/blob/main/CODE_OF_CONDUCT.md).
