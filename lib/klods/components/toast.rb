module Klods
  module Components
    module Toast
      # Renders the live region container. Mount this once in your layout;
      # individual toasts are appended inside it (via JS on the client, or
      # server-rendered for SSR pre-populated notifications).
      def toast_region(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        attrs = {
          "class" => "klods-toast-region",
          "aria-live" => "polite",
          "aria-atomic" => "false",
          "role" => "region",
          "aria-label" => "Notifications"
        }.merge(props.transform_keys(&:to_s))
        Core.el("div", attrs, children)
      end

      def toast(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        props = props.transform_keys(&:to_s)
        variant = props.delete("variant")
        extra_class = props.delete("class")
        cls = Core.class_names(
          "klods-toast",
          (variant && variant.to_s != "default") ? "klods-toast--#{variant}" : nil,
          Core.resolve_class(extra_class)
        )
        attrs = props.merge("role" => "status", "class" => cls.empty? ? nil : cls).compact
        body = Core.el("span", {"class" => "klods-toast__body"}, children)
        dismiss_js = "var e=this.closest('.klods-toast');if(e){e.setAttribute('data-dismissing','');var f=setTimeout(function(){e.remove()},200);e.addEventListener('animationend',function(){clearTimeout(f);e.remove()},{once:true})}"
        close_btn = Core.el("button", {"type" => "button", "class" => "klods-toast__close", "aria-label" => "Dismiss", "onclick" => dismiss_js})
        Core.el("div", attrs, [body, close_btn])
      end

      # Renders a button that dynamically creates and shows a toast on click.
      # message: the toast body text (string). toast_variant: toast style. duration: ms (0 = persistent).
      def toast_trigger(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        props = props.transform_keys(&:to_s)
        message = props.delete("message")
        message = children if message.nil?
        variant = props.delete("toast_variant") || "default"
        duration = props.key?("duration") ? props.delete("duration").to_i : 5000

        escaped = message.to_s.gsub(/[\\']/) { |c| "\\#{c}" }
        toast_class = (variant.to_s == "default") ? "klods-toast" : "klods-toast klods-toast--#{variant}"

        dismiss_fn = "function _kd(e){e.setAttribute('data-dismissing','');var f=setTimeout(function(){e.remove()},200);e.addEventListener('animationend',function(){clearTimeout(f);e.remove()},{once:true})}"
        get_region = "var r=document.querySelector('.klods-toast-region');" \
          "if(!r){r=document.createElement('div');r.className='klods-toast-region';" \
          "r.setAttribute('aria-live','polite');r.setAttribute('aria-atomic','false');" \
          "r.setAttribute('role','region');r.setAttribute('aria-label','Notifications');" \
          "document.body.appendChild(r)}"
        make_toast = "var t=document.createElement('div');t.className='#{toast_class}';t.setAttribute('role','status');" \
          "var b=document.createElement('span');b.className='klods-toast__body';b.textContent='#{escaped}';t.appendChild(b);" \
          "var c=document.createElement('button');c.type='button';c.className='klods-toast__close';" \
          "c.setAttribute('aria-label','Dismiss');c.onclick=function(){_kd(t)};t.appendChild(c);r.appendChild(t)"
        auto_dismiss = (duration > 0) ? ";setTimeout(function(){_kd(t)},#{duration})" : ""
        onclick = "(function(){#{dismiss_fn};#{get_region};#{make_toast}#{auto_dismiss}})()"

        Core.build(tag: "button", base: "klods-button",
          modifiers: {variant: ->(v) { (v && v.to_s != "default") ? "klods-button--#{v}" : nil }},
          props: props.merge("type" => "button", "onclick" => onclick),
          children: children)
      end

      # Renders a button that removes all visible toasts on click.
      def clear_toasts_trigger(a = nil, b = nil)
        props, children = Core.normalize_args(a, b)
        onclick = "document.querySelectorAll('.klods-toast-region').forEach(function(r){r.remove()})"
        Core.build(tag: "button", base: "klods-button",
          modifiers: {variant: ->(v) { (v && v.to_s != "default") ? "klods-button--#{v}" : nil }},
          props: props.transform_keys(&:to_s).merge("type" => "button", "onclick" => onclick),
          children: children)
      end
    end
  end
end
