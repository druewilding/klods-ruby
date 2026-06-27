# klods-ruby — CLAUDE.md

## What this is

Ruby builder API for [klods](https://www.druewilding.com/klods/) — a CSS+JS component library. Every Ruby method maps 1-to-1 with a TypeScript counterpart in klods-js: `camelCase` → `snake_case`, identical HTML output.

The golden rule of klods: **CSS + JS + docs must all stay in sync.** If you add a modifier prop here, it must already exist in klods-css. Don't invent new props.

## Architecture

### Core types

- **`Klods::Node`** (`lib/klods/node.rb`) — the only output type. Has `tag`, `attrs` (String-keyed hash), `children` (Array). Serialises to HTML via `to_s`. Void tags (br, img, input, etc.) never have children. Non-string children are HTML-escaped; `RawHtml` children are emitted verbatim.
- **`Klods::RawHtml`** (`lib/klods/node.rb`) — wraps a pre-escaped HTML string so it bypasses child escaping. Created via `Core.raw(str)`.

### Core utilities (`lib/klods/core.rb`)

- **`Core.normalize_args(a, b)`** — the universal arg splitter. If `a` is a Hash or nil → `[props, b]`. Otherwise → `[{}, a]`. All builder methods call this first.
- **`Core.build(...)`** — BEM factory. Takes `tag:`, `base:` CSS class, `modifiers:` hash, `props:`, `children:`. Modifiers are either a string (added when prop is truthy) or a lambda `(v) { class_or_nil }`. Everything not matched by a modifier is passed through as an HTML attribute.
- **`Core.el(tag, a, b)`** — thin wrapper for plain HTML elements with no BEM class. Uses `normalize_args`.
- **`Core.raw(str)`** — creates a `RawHtml` node. Use for pre-rendered HTML you don't want escaped.
- **`Core.slug_id(prefix, text)`** — generates a stable CSS-friendly `id` from a prefix and text string. Used by `field` and `tabs` for auto-generated ids.

### Module structure

```
lib/klods/
  builders.rb        # Aggregates all modules; defines klods_capture (private)
  core.rb            # Core utilities
  node.rb            # Node + RawHtml
  html.rb            # Raw HTML tag shortcuts (p, div, h1–h6, a, span, ...)
  layout.rb          # page, header, sidebar, content, footer, stack, cluster, ...
  utilities.rb       # push, fill
  icons.rb           # All 19 icon builders
  rails_safety.rb    # RailsSafety module (prepended on Node in Rails)
  railtie.rb         # Includes Builders into ActionView::Base, prepends RailsSafety
  components/
    alert.rb  avatar.rb  badge.rb  box.rb  breadcrumb.rb  button.rb
    card.rb   code.rb    details.rb  dl.rb  form.rb  list.rb
    modal.rb  nav.rb     prose.rb    table.rb  tabs.rb  toast.rb
    tooltip.rb
```

`Klods::Builders` includes all the modules and is the single include point for consumers.

### Builder method signature

Every builder that accepts children uses this exact pattern:

```ruby
def method_name(a = nil, b = nil, &block)
  props, children = Core.normalize_args(a, b)
  children = klods_capture(&block) if block
  Core.build(tag: ..., base: ..., props: props, children: children)
end
```

`klods_capture` (private, in `builders.rb`) uses ActionView's `capture` to collect HAML/ERB block output as HTML and returns `[Core.raw(html)]`. It returns `nil` outside Rails (so `children` falls back to whatever was passed as an arg).

**Block takes precedence over explicit children** — if both are passed, the block wins.

### Methods that deviate from the standard pattern

- **`field(props, &block)`** — block yields the auto-generated `id`; the block must return a Node (an `input`, `select`, etc.). Do NOT add `klods_capture` here.
- **`tabs(a, b)`** — NO block support. Introspects children as `Node` objects to extract `data-tab-label` attributes and build the tab list. Raw HTML from `capture` would break this.
- **`tooltip(target_or_props, target_or_nil)`** — positional-signature wrapper; no block.
- **`breadcrumbs(crumbs, attrs)`** — positional signature; no block.
- **`toast_trigger`**, **`clear_toasts_trigger`** — fixed widget structure; no block needed.
- **`modal_close`** — leaf button; no children concept.
- **`input`**, **`checkbox`**, **`radio`**, **`radio_group`**, **`switch_input`** — form leaf elements.
- **`sidebar_toggle`**, **`text`** — layout leaf elements.
- **`push`**, **`fill`** — have `&block` in case someone wants to put content inside, but are normally used as spacers with no children.

### Rails integration

The Railtie does two things at boot:
1. `include Klods::Builders` into `ActionView::Base` — all builders are available in every view and helper.
2. `Klods::Node.prepend(Klods::RailsSafety)` — `Node#to_s` returns an `html_safe` string so HAML and ERB never double-escape the output.

### Why `klods_capture` works in HAML

HAML 6 with `haml-rails` sets `disable_capture: true`, which makes the block generator write directly to `@output_buffer` rather than to a Temple local buffer. ActionView's `OutputBuffer#capture` temporarily swaps `@raw_buffer` to a new string, lets the HAML block write into it, then restores — the captured content is returned. Multiple nested `= method do ... end` calls nest safely because each `capture` push/pops `@raw_buffer` in an `ensure` block.

## HAML usage rules

In HAML 6, `=` output lines must be a **single Ruby expression**. Multi-line array literals fail because HAML inserts a semicolon after the opening `[`.

Two valid patterns:

**Block syntax** (preferred for nesting):
```haml
= stack({ gap: 4 }) do
  = prose do
    = h1({ id: "welcome" }, "Welcome")
    = p("Text here.")
  = cluster({ gap: 2 }) do
    = button({ variant: "primary" }, "Save")
    = button("Cancel")
```

**Variable assignment** (for one-liners you want to reuse):
```haml
- actions = cluster({ gap: 2 }, [button({ variant: "primary" }, "Save"), button("Cancel")])
= stack({ gap: 4 }) do
  = prose do
    = h1("Title")
  = actions
```

For `= method do` with inline content that isn't a block call:
```haml
= p do
  = "Edit "
  = inline_code("config/routes.rb")
  = " to add routes."
```

`content_for` with a value (not block form) for sidebar:
```haml
- content_for :sidebar, toc([toc_item(toc_link({ href: "#intro" }, "Introduction"))])
```

## Spec organisation

```
spec/
  spec_helper.rb          # RSpec config; resets tooltip counter before each test
  core_spec.rb            # Core utilities
  node_spec.rb            # Node serialisation, escaping, void tags
  block_capture_spec.rb   # Block syntax with FakeCapture stub (simulates ActionView)
  components/             # One file per component
```

The `FakeCapture` stub in `block_capture_spec.rb` defines `capture(&block) = block.call.to_s` — this works because in plain-Ruby tests (no ActionView) the blocks return the last Node directly rather than writing to a buffer.

Run tests: `bundle exec rspec`
Check style: `bundle exec standardrb`
Auto-fix style: `bundle exec standardrb --fix`

## Releasing

Releases use [Release Please](https://github.com/googleapis/release-please). Commits must follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` → minor bump
- `fix:` → patch bump
- `docs:` / `chore:` → no release

Release Please opens a PR that bumps `lib/klods/version.rb` and updates `CHANGELOG.md`. Merging that PR triggers the RubyGems publish via CI.

Current version: `1.1.0` (block/`do` syntax support added).

## What NOT to do

- Don't add modifier props that don't exist in klods-css — the CSS classes won't be there.
- Don't add `klods_capture` to `field` — it already uses `&block` to receive the input builder.
- Don't add `klods_capture` to `tabs` — it introspects children as `Node` objects.
- Don't use `Core.raw` on user-provided strings that haven't been sanitised — it bypasses escaping.
- Don't use `with_output_buffer` instead of `@output_buffer.capture` — the Rails 7.2 implementation uses the latter.
