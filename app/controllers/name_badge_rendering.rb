module NameBadgeRendering
  def send_badge(people)
    people = Array(people)
    people.each { |person| QrCodePng.write(person) }
    send_data NameBadgePdf.render(people),
      :filename => "badge.pdf",
      :type => "application/pdf",
      :disposition => "inline"
  end

  def mark_printed(people)
    Array(people).each { |person| person.update_attribute(:printed, true) }
  end
end
