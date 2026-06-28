# klods-ruby Roadmap

Ideas and known gaps, roughly in priority order. Not a commitment — just an honest list of what would make this better.

---

## Rails FormBuilder integration

The most impactful improvement. Right now, `field` expects its block to return a klods `Node` so it can patch aria attributes onto it:

```ruby
= field({ label: "Email" }) do |id|
  = input({ type: "email", id: id })   # returns a Node ✓
```

Rails form helpers return HTML-safe strings, not Nodes, so they don't work in the block:

```ruby
= field({ label: "Email" }) do |id|
  = f.email_field :email, id: id      # returns a String — _patch_aria_attrs breaks ✗
```

The workaround in Rails projects is to use klods CSS classes directly on Rails helpers:

```haml
%div.klods-field
  = f.label :email, "Email", class: "klods-label"
  = f.email_field :email, class: "klods-input"
```

This works fine but bypasses the Ruby API entirely (no help text, no error state, no aria wiring).

**The fix:** a `KlodsFormBuilder` that integrates with Rails' `FormBuilder` API:

```ruby
= form_with model: @user, builder: KlodsFormBuilder do |f|
  = f.klods_field :email, label: "Email"
  = f.klods_field :password, label: "Password", type: :password
  = f.klods_submit "Save"
```

`klods_field` would generate the full `klods-field` wrapper, label, input, help text, and error message — wired to the model's validation errors automatically.

This is a meaningful addition: a `lib/klods/rails/form_builder.rb` that subclasses `ActionView::Helpers::FormBuilder`, with specs and documentation. It does not replace Rails form helpers; it wraps them.

---

## Error state from Rails model validations

Related to the above. Right now `field` accepts an `error:` string manually:

```ruby
= field({ label: "Email", error: "can't be blank" }) do |id| ...
```

In a Rails context you want this to come from `@user.errors[:email]` automatically. The `KlodsFormBuilder` above would handle this — `f.klods_field(:email)` would check `object.errors[:email].first` and pass it as the error.

---

## `field` graceful degradation for HTML-safe strings

A smaller step before the full FormBuilder: make `field`'s block accept either a Node or an HTML-safe string. If the block returns a string, skip `_patch_aria_attrs` and embed it as raw HTML. This lets Rails helpers work in the block without a full FormBuilder, at the cost of not patching aria attributes onto the input.

```ruby
= field({ label: "Email" }) do |id|
  = f.email_field :email, id: id    # would work, aria patching skipped
```

---

## Parity with klods-js

A periodic check to ensure every component and variant in klods-js has a Ruby equivalent. As klods-js adds new components or options, klods-ruby should follow. Worth reviewing on each klods-js minor release.

---

## `page` layout helpers

The `page`, `header`, `sidebar`, `content`, `footer` shell — currently these live in views directly. A Rails layout generator (`rails generate klods:layout`) that scaffolds `application.html.haml` with the full klods shell would reduce copy-paste between projects.

---

## Non-goals

- **Replacing Rails form helpers** — `f.text_field`, `f.select` etc. are good. The goal is to style and wrap them, not duplicate them.
- **Server-side rendering of interactive components** — modals, tabs, toast etc. rely on klods-js. klods-ruby renders the correct HTML structure; JS handles the behaviour.
