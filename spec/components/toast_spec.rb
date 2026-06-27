require "spec_helper"

RSpec.describe "toast" do
  include Klods::Builders

  it "renders toast_region with aria attributes" do
    html = toast_region.to_s
    expect(html).to include("klods-toast-region")
    expect(html).to include('aria-live="polite"')
    expect(html).to include('role="region"')
    expect(html).to include('aria-label="Notifications"')
  end

  it "renders toast with body and close button" do
    html = toast("Message").to_s
    expect(html).to include("klods-toast")
    expect(html).to include("klods-toast__body")
    expect(html).to include("Message")
    expect(html).to include("klods-toast__close")
    expect(html).to include('aria-label="Dismiss"')
  end

  it "applies variant modifier to toast" do
    expect(toast({variant: "success"}, "Saved").to_s).to include("klods-toast--success")
  end

  it "toast close button self-wires dismiss via inline JS" do
    html = toast("Hi").to_s
    expect(html).to include("onclick=")
    expect(html).to include("data-dismissing")
    expect(html).to include("closest('.klods-toast')")
  end

  it "toast close button uses setTimeout for animation" do
    expect(toast("Hi").to_s).to include("setTimeout")
  end

  describe "toast_trigger" do
    it "renders as a button with klods-button class" do
      html = toast_trigger({message: "Saved!"}, "Show toast").to_s
      expect(html).to start_with("<button")
      expect(html).to include("klods-button")
      expect(html).to include("Show toast")
    end

    it "has type=button" do
      expect(toast_trigger({message: "Hi"}, "Go").to_s).to include('type="button"')
    end

    it "includes inline JS that creates a toast on click" do
      html = toast_trigger({message: "File saved!"}, "Save").to_s
      expect(html).to include("onclick=")
      expect(html).to include("klods-toast")
      expect(html).to include("File saved!")
    end

    it "sets toast message via textContent (safe)" do
      html = toast_trigger({message: "All good."}, "Go").to_s
      expect(html).to include("textContent=")
    end

    it "creates the toast region if absent" do
      html = toast_trigger({message: "Hi"}, "Go").to_s
      expect(html).to include("klods-toast-region")
      expect(html).to include("appendChild")
    end

    it "applies toast variant class in the JS" do
      html = toast_trigger({message: "Saved", toast_variant: "success"}, "OK").to_s
      expect(html).to include("klods-toast--success")
    end

    it "defaults to klods-toast class for default variant" do
      html = toast_trigger({message: "Hi"}, "Go").to_s
      expect(html).not_to include("klods-toast--default")
    end

    it "auto-dismisses by default after 5000ms" do
      html = toast_trigger({message: "Hi"}, "Go").to_s
      expect(html).to include("5000")
    end

    it "supports duration: 0 for persistent toasts" do
      html = toast_trigger({message: "Persistent", duration: 0}, "Go").to_s
      expect(html).not_to include("setTimeout(function(){_kd(t)},0)")
    end

    it "supports button variant prop" do
      html = toast_trigger({message: "Oops", variant: "danger"}, "Danger").to_s
      expect(html).to include("klods-button--danger")
    end

    it "uses button label as message when no message prop given" do
      html = toast_trigger("Quick toast").to_s
      expect(html).to include("Quick toast")
    end

    it "escapes single quotes in message" do
      html = toast_trigger({message: "Don't panic"}, "Go").to_s
      expect(html).to include("Don\\'t panic")
    end
  end

  describe "clear_toasts_trigger" do
    it "renders as a button" do
      html = clear_toasts_trigger("Clear all").to_s
      expect(html).to start_with("<button")
      expect(html).to include("Clear all")
    end

    it "includes inline JS that removes all toast regions" do
      html = clear_toasts_trigger("Clear").to_s
      expect(html).to include("klods-toast-region")
      expect(html).to include("remove()")
    end
  end
end
