require "spec_helper"

describe Person do
  it "requires a name, email, phone, and registration" do
    person = Person.new
    expect(person).not_to be_valid
    [:fname, :lname, :email, :phone, :registration].each do |attribute|
      expect(person.errors[attribute]).not_to be_empty
    end
  end

  it "rejects an email that is not an address" do
    person = build_person(:email => "not-an-email")
    expect(person).not_to be_valid
    expect(person.errors[:email]).not_to be_empty
  end

  it "requires a 14 character phone number" do
    person = build_person(:phone => "555-1212")
    expect(person).not_to be_valid
    expect(person.errors[:phone].join).to include("should be in the format of (XXX) XXX-XXXX")
  end

  it "rejects a duplicate email regardless of case" do
    create_person(:email => "Ada@Example.com")
    duplicate = build_person(:email => "ada@example.com")
    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:email]).not_to be_empty
  end

  it "builds a MECARD from the attendee and company" do
    person = build_person(
      :fname => "John",
      :lname => "Doe",
      :email => "john@example.com",
      :phone => "(415) 555-1212"
    )
    person.company_name = "Acme"
    expect(person.mecard).to eq("MECARD:N:John Doe;TEL:(415) 555-1212;EMAIL:john@example.com;NOTE:Acme;;")
  end

  it "finds or creates a company by name" do
    existing = Company.create!(:name => "Acme")
    person = build_person
    person.company_name = "Acme"
    expect(person.company).to eq(existing)
    expect(Company.where(:name => "Acme").count).to eq(1)

    person.company_name = "New Co"
    expect(Company.find_by(name: "New Co")).to be_present
  end

  def build_person(attrs = {})
    registration = attrs.delete(:registration) || create_registration
    Person.new({
      :fname => "John",
      :lname => "Doe",
      :email => "john#{rand(100000)}@example.com",
      :phone => "(415) 555-1212",
      :registration => registration
    }.merge(attrs))
  end
end
