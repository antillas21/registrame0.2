module RecordHelpers
  def create_user(attrs = {})
    serial = rand(100000)
    admin = attrs.delete(:admin)
    user = User.create!({
      :username => "user#{serial}",
      :email => "user#{serial}@example.com",
      :password => "password",
      :password_confirmation => "password"
    }.merge(attrs))
    user.update_attribute(:admin, admin) unless admin.nil?
    user
  end

  def create_registration(name = nil)
    Registration.create!(:name => name || "Visitor #{rand(100000)}")
  end

  def create_person(attrs = {})
    registration = attrs.delete(:registration) || create_registration
    serial = rand(100000)
    Person.create!({
      :fname => "John",
      :lname => "Doe",
      :email => "john#{serial}@example.com",
      :phone => "(415) 555-1212",
      :registration => registration
    }.merge(attrs))
  end

  def create_name_badge
    NameBadge.create!(
      :name => "Default",
      :width => 4,
      :height => 4,
      :left => 0.2,
      :right => 0.2,
      :top => 0.2,
      :bottom => 0.2,
      :font_size => 16
    )
  end
end
