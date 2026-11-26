require "spec_helper"

describe NameBadge do
  it "requires a name, width, height, and font size" do
    badge = NameBadge.new
    expect(badge).not_to be_valid
    [:name, :width, :height, :font_size].each do |attribute|
      expect(badge.errors[attribute]).not_to be_empty
    end
  end
end
