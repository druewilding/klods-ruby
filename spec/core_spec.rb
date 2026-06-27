require "spec_helper"

RSpec.describe Klods::Core do
  describe ".normalize_args" do
    it "treats a hash as props" do
      props, children = described_class.normalize_args({class: "x"}, "text")
      expect(props).to eq({class: "x"})
      expect(children).to eq("text")
    end

    it "treats a non-hash first arg as children" do
      props, children = described_class.normalize_args("text")
      expect(props).to eq({})
      expect(children).to eq("text")
    end

    it "treats nil first arg as empty props" do
      props, children = described_class.normalize_args(nil, "text")
      expect(props).to eq({})
      expect(children).to eq("text")
    end

    it "treats an array as children" do
      props, children = described_class.normalize_args(["a", "b"])
      expect(props).to eq({})
      expect(children).to eq(["a", "b"])
    end

    it "treats a Klods::Node as children" do
      node = Klods::Node.new("span", {}, "hi")
      props, children = described_class.normalize_args(node)
      expect(props).to eq({})
      expect(children).to eq(node)
    end
  end

  describe ".slug_id" do
    it "converts a label to a safe id segment" do
      expect(described_class.slug_id("klods-field", "Email address")).to eq("klods-field-email-address")
    end

    it "strips leading and trailing hyphens" do
      expect(described_class.slug_id("pre", "First name")).to eq("pre-first-name")
    end

    it "collapses multiple non-alphanumeric chars to one hyphen" do
      expect(described_class.slug_id("x", "hello   world!")).to eq("x-hello-world")
    end
  end

  describe ".raw" do
    it "returns a RawHtml that passes through unescaped" do
      raw = described_class.raw("<em>hi</em>")
      expect(raw).to be_a(Klods::RawHtml)
      expect(raw.to_s).to eq("<em>hi</em>")
    end
  end

  describe ".resolve_class" do
    it "returns a string as-is" do
      expect(described_class.resolve_class("foo bar")).to eq("foo bar")
    end

    it "joins an array" do
      expect(described_class.resolve_class(["foo", "bar"])).to eq("foo bar")
    end

    it "filters truthy hash keys" do
      expect(described_class.resolve_class({foo: true, bar: false, baz: true})).to eq("foo baz")
    end

    it "handles nil" do
      expect(described_class.resolve_class(nil)).to eq("")
    end
  end
end
