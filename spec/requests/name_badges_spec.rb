require "spec_helper"

describe "Name badges", :type => :request do
  PNG_HEADER = "\x89PNG\r\n\x1A\n".force_encoding("ASCII-8BIT")

  before do
    create_name_badge
    sign_in_as(create_user)
  end

  after do
    Dir[Rails.root.join("public/images/qrcodes/*.png")].each { |path| File.delete(path) }
  end

  it "prints a badge pdf and a qr png for one attendee" do
    person = create_person

    get "/data/people/#{person.id}.pdf"

    expect(response.body).to start_with("%PDF")
    expect(person.reload.printed).to eq(true)
    png = File.binread(Rails.root.join("public/images/qrcodes/#{person.id}.png"))
    expect(png.byteslice(0, 8)).to eq(PNG_HEADER)
  end

  it "prints a badge page for each person at a company" do
    company = Company.create!(:name => "Acme")
    first = create_person(:company => company, :email => "first@example.com")
    second = create_person(:company => company, :email => "second@example.com")

    get "/companies/#{company.id}/people.pdf"

    expect(response.body).to start_with("%PDF")
    expect(first.reload.printed).to eq(true)
    expect(second.reload.printed).to eq(true)
    [first, second].each do |person|
      png = File.binread(Rails.root.join("public/images/qrcodes/#{person.id}.png"))
      expect(png.byteslice(0, 8)).to eq(PNG_HEADER)
    end
  end
end
