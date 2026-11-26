require "rqrcode"
require "chunky_png"
require "fileutils"

class QrCodePng
  def self.write(person)
    new(person).write
  end

  def initialize(person)
    @person = person
  end

  def write
    directory = Rails.root.join("public", "images", "qrcodes")
    FileUtils.mkdir_p(directory)
    path = directory.join("#{@person.id}.png")
    image.save(path.to_s)
    path
  end

  private

  def image
    qr = RQRCode::QRCode.new(@person.mecard)
    modules = qr.modules
    scale = 6
    size = modules.length * scale
    png = ChunkyPNG::Image.new(size, size, ChunkyPNG::Color::WHITE)
    modules.each_index do |row|
      modules.each_index do |column|
        next unless modules[row][column]
        scale.times do |offset_y|
          scale.times do |offset_x|
            png[(column * scale) + offset_x, (row * scale) + offset_y] = ChunkyPNG::Color::BLACK
          end
        end
      end
    end
    png
  end
end
