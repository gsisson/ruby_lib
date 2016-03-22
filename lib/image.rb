#!/usr/bin/env ruby

class Image
  def self.convert_png_to_jpg png_file, jpg_file
    cmd = "'c:/Program Files/ImageMagick-6.9.0-Q16/convert' '#{png_file}' '#{jpg_file}'"
    puts "# "+"Converting png to jpg".cyan.bold
    puts "# convert '#{png_file}'"
    puts "#      to '#{jpg_file}'"
    system cmd
  end
  def self.convert_gif_to_jpg gif_file, jpg_file
    cmd = "'c:/Program Files/ImageMagick-6.9.0-Q16/convert' '#{gif_file}' '#{jpg_file}'"
    puts "# "+"Converting gif to jpg".cyan.bold
    puts "# convert '#{gif_file}'"
    puts "#      to '#{jpg_file}'"
    system cmd
  end
end

