pdf.font_size = NameBadge.first.font_size

pdf.text @person.full_name, :style => :bold, :align => :center
pdf.text @person.company_name, :align => :center unless @person.company.nil?
pdf.text @person.registration_name, :align => :center unless @person.registration.nil?

qrcode = "#{RAILS_ROOT}/public/images/qrcodes/#{@person.id}.png"
pdf.image qrcode, :position => :center, :vposition => :bottom, :scale => 0.7