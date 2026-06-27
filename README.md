# klods-ruby

> Ruby builder API for [klods](https://github.com/druewilding/klods) — same components, same call shapes, same HTML output.

`klods-ruby` lets you use klods in any Ruby project (Rails, Sinatra, plain Ruby) without touching JavaScript. Every builder maps 1-to-1 with its TypeScript counterpart: `camelCase` becomes `snake_case`, everything else stays the same.

📖 **[klods docs →](https://www.druewilding.com/klods/)**

## Installation

```sh
gem install klods-ruby
```

Or add to your `Gemfile`:

```ruby
gem "klods-ruby"
```

You still need the CSS. Grab it from a CDN:

```html
<link rel="stylesheet" href="https://unpkg.com/klods-css/dist/klods.min.css" />
```

Or install via npm and serve it yourself:

```sh
npm install klods-css
```

## Quick start

### Plain Ruby

```ruby
require "klods"
include Klods::Builders

puts card([
  card_title("Hello"),
  card_body("Snap blocks together like lego.")
])
```

### Rails (ERB)

Add to an initializer or `application.rb` — the Railtie wires everything up automatically:

```erb
<%= page({sidebar: true}, [
  header([
    span("My App"),
    push,
    nav_link({href: "/", active: true}, "Home"),
    nav_link({href: "/about"}, "About")
  ]),
  sidebar([
    toc([
      toc_item(toc_link({href: "#intro"}, "Introduction")),
      toc_item(toc_link({href: "#usage"}, "Usage"))
    ])
  ]),
  content(
    card([
      card_title("Welcome"),
      card_body("Build pages with Ruby.")
    ])
  ),
  footer("© 2026")
]) %>
```

All builders return `Klods::Node`, which Rails treats as HTML-safe — no `html_safe` calls needed.

## Call shapes

Every builder accepts three forms — use the shortest that fits:

```ruby
badge                                    # no args
badge("Done")                            # children only
badge({variant: "success"}, "Done")      # props + children
```

## Components

### Layout

```ruby
page({sidebar: true, sticky_header: true}, [...])
header("My App")
sidebar([...])
content({narrow: true}, [...])
footer("© 2026")
section([...])
stack({gap: 4}, [...])
cluster({gap: 2}, [...])
row([...])
grid({cols: 3, gap: 4}, [...])
center([...])
spread([...])
push                     # flex spacer — pushes siblings to end of row
fill([...])              # grows to fill available space
sidebar_toggle           # hamburger button for mobile sidebar
```

### Components

```ruby
card([card_title("Title"), card_body("Body"), card_footer("Footer")])
card({elevated: true}, [...])

badge                          # span.klods-badge
badge({variant: "success"}, "Done")
badge({variant: "danger"}, "!")
badge({variant: "accent"}, "New")

alert("Something went wrong.")
alert({variant: "info"}, "FYI")
alert({variant: "success"}, "Saved.")
alert({variant: "warning"}, "Check this.")
alert({variant: "danger"}, "Error!")

button("Click me")
button({variant: "primary"}, "Save")
button({variant: "danger"}, "Delete")
button({variant: "ghost"}, "Cancel")
button({type: "submit"}, "Submit")

box("Content in a box")

prose([h1("Heading"), p("Paragraph text.")])
muted("Secondary text")
lead("A lead paragraph.")
text_center([...])
```

### Navigation

```ruby
nav([nav_list([
  nav_link({href: "/", active: true}, "Home"),
  nav_link({href: "/about"}, "About")
])])

nav({collapse: true}, [...])  # collapsible with hamburger toggle
nav_toggle                    # renders the hamburger button

toc([
  toc_item(toc_link({href: "#section"}, "Section")),
  toc_item(toc_link({href: "#sub"}, "Sub"), toc({sub: true}, [...]))
])

button_group([button("A"), button("B")])
```

### Forms

`field` takes a block that receives the auto-generated `id`:

```ruby
form([
  field({label: "Email", required: true}) { |id|
    input(id: id, type: "email", placeholder: "you@example.com")
  },
  field({label: "Message", help: "Max 500 characters"}) { |id|
    textarea(id: id)
  },
  field({label: "Plan", error: "Please choose a plan"}) { |id|
    select(id: id, [
      option({value: ""}, "Choose…"),
      option({value: "free"}, "Free"),
      option({value: "pro"}, "Pro")
    ])
  },
  checkbox({label: "I agree to the terms", name: "terms", value: "1"}),
  radio_group({legend: "Colour"}, [
    radio({label: "Red", name: "colour", value: "red"}),
    radio({label: "Blue", name: "colour", value: "blue"})
  ]),
  switch_input({label: "Enable notifications", name: "notify"}),
  button({type: "submit", variant: "primary"}, "Submit")
])
```

`field` automatically:
- Generates an `id` from the label when none is provided
- Wires `for` on the label and `id` on the input
- Adds `aria-describedby` pointing to the help or error text
- Adds `aria-invalid="true"` on the input when an error is present

### Interactive

```ruby
# Modal — open/close is wired by client JS
modal([
  modal_panel([
    modal_header([modal_title("Confirm"), modal_close]),
    modal_body("Are you sure?"),
    modal_actions([button("Cancel"), button({variant: "danger"}, "Delete")])
  ])
])

# Tabs
tabs([
  tab_panel({label: "Account"}, [...]),
  tab_panel({label: "Security"}, [...])
])

# Disclosure
details([summary("Show more"), p("Hidden content.")])

# Tooltip
tooltip({tip: "Click to copy", position: "above"}, button("Copy"))

# Toast region — render once in your layout; toast() for SSR pre-filled notifications
toast_region
toast({variant: "success"}, "Changes saved.")
```

### Data display

```ruby
# Breadcrumbs
breadcrumbs([
  crumb({href: "/"}, "Home"),
  crumb({href: "/products"}, "Products"),
  crumb("Widget")
])

# Description list
dl([
  dt("Name"), dd("Drue Wilding"),
  dt("Role"), dd("Developer")
])
dl({inline: true}, [...])

# Table
table_wrap(
  table({striped: true}, [
    thead(tr([th("Name"), th("Role")])),
    tbody([
      tr([td("Drue"), td("Developer")])
    ])
  ])
)

# List
list([
  list_item("Plain item"),
  list_item({href: "/page"}, "Link item"),
  list_item({lead: badge("!"), trail: chev_right_icon}, "With slots")
])

# Avatar
avatar({src: "/photo.jpg", name: "Drue Wilding"})
avatar({name: "Drue Wilding"})    # falls back to initials DW
avatar                            # falls back to user icon
```

### Code

```ruby
code_block("npm install klods-ruby")
inline_code("Klods::Node")
kbd("Ctrl+S")
samp("output text")
```

### Icons

All 19 icons from klods-js, in `snake_case`:

```ruby
check_circle_icon
chev_down_icon    chev_left_icon    chev_right_icon    chev_up_icon
close_icon        copy_icon         danger_circle_icon  edit_icon
external_link_icon eye_icon         eye_off_icon        info_circle_icon
menu_icon         plus_icon         search_icon         trash_icon
user_icon         warning_icon
```

Each accepts optional props:

```ruby
search_icon({size: "large", label: "Search"})
# size: "small" | "medium" | "large" (default: "medium")
# label: accessible text — omit for decorative use
```

### HTML tag shortcuts

For raw HTML elements with no BEM class:

```ruby
p("Paragraph")
span("Inline")
div({class: "wrapper"}, [...])
ul([li("a"), li("b")])
a({href: "/path"}, "Link")
h1("Heading")              # h1 through h6
strong("Bold")   em("Italic")
code("snippet")  pre(code("block"))
img({src: "/logo.png", alt: "Logo"})
br    hr
```

Tags that share a name with a klods component (`nav`, `button`, `form`, `table`, etc.) are intentionally omitted — use the klods component or `el("tag", ...)` for the unstyled version.

### Escape hatch

```ruby
el("time", {datetime: "2026-01-01"}, "1 January 2026")
raw("<strong>Pre-escaped HTML</strong>")
```

## Themes

Apply a theme with a `data-theme` attribute on any ancestor element:

```html
<html data-theme="dark">
<div data-theme="playful">...</div>
<div data-theme="brutalist">...</div>
```

## Development

```sh
bundle install
bundle exec rspec          # run tests
bundle exec standardrb     # check style
bundle exec standardrb --fix  # auto-fix style
```

## Releasing

Releases are automated with [Release Please](https://github.com/googleapis/release-please):

1. Commit with [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`, `docs:`, `chore:`)
2. Release Please opens a Release PR bumping `version.rb` and updating `CHANGELOG.md`
3. Merging that PR publishes the gem to RubyGems automatically

### First-time setup

Two secrets are needed in the repo settings:

| Secret | Where to get it |
|--------|----------------|
| `RELEASE_PLEASE_TOKEN` | GitHub → Settings → Developer settings → Personal access tokens (needs `contents` and `pull-requests` write) |
| `RUBYGEMS_API_KEY` | rubygems.org → Account → API keys |

## License

MIT
