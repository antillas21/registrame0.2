require "prawn"
require "prawn/measurement_extensions"

class NameBadgePdf
  def self.render(people)
    new(people).to_pdf
  end

  def initialize(people)
    @people = Array(people)
  end

  def to_pdf
    label = NameBadge.first
    raise "Configure a name badge before printing." if label.nil?

    pdf = Prawn::Document.new(
      :page_layout => :portrait,
      :left_margin => label.left.to_f.in,
      :right_margin => label.right.to_f.in,
      :top_margin => label.top.to_f.in,
      :bottom_margin => label.bottom.to_f.in,
      :page_size => [label.width.to_f.in, label.height.to_f.in]
    )
    pdf.font "Helvetica"

    @people.each_with_index do |person, index|
      pdf.start_new_page unless index.zero?
      draw_person(pdf, person, label)
    end

    pdf.render
  end

  private

  def draw_person(pdf, person, label)
    pdf.font_size = label.font_size
    pdf.text person.full_name, :style => :bold, :align => :center
    pdf.text person.company_name, :align => :center unless person.company.nil?
    pdf.text person.registration_name, :align => :center unless person.registration.nil?
    qrcode = Rails.root.join("public", "images", "qrcodes", "#{person.id}.png").to_s
    pdf.image qrcode, :position => :center, :vposition => :bottom, :scale => 0.7
  end
end
