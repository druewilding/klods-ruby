# klods-ruby Roadmap

Ideas and known gaps, roughly in priority order. Not a commitment — just an honest list of what would make this better.

---

## ✅ Rails FormBuilder integration

`Klods::FormBuilder` is available as of v1.3.0. See the README for usage.

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
