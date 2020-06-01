require 'nokogiri'
require 'open-uri'
url = "https://www.carjam.co.nz/car/?plate="
attributes = %w(year_of_manufacture make model submodel main_colour body_style engine_number cc_rating fuel_type)
str = %w(Year: Make: Model: Submodel: Colour: Body\ Style: Engine\ Serial: CC\ Rating: Fuel\ Type:)
infotext = Array.new

@bot.command(:carjam, help_available: false, chain_usable: false) do |event, text|
  plate = text
  puts "#{info}CarJam Query for plate #{text}"
  open(url+plate).read
  sleep 1
  open(url+plate).read
  sleep 1
  open(url+plate).read
  sleep 1
  if open(url+plate).read["Vehicle Facts"]
    event.channel.send_embed do |e|
      e.title = "#{plate.upcase} is invalid"
      e.description = "#{plate.upcase} is either invalid, or has never been registered.\nValid plates are up to 6 characters long, VINs are 17 characters long"
      e.color = 'ff0000'
    end
  else
    doc = Nokogiri::HTML(open(url+plate))
    infotext.clear
    attributes.each_with_index do |attrib, index|
      doc.css("[data-key=#{attrib}] + .value").each do |item|
        infotext.push("#{str[index]} #{item.inner_html.strip.gsub('<span class="terminal">', '').gsub(/(<[^>]*>)|\n|\t/s) {" "}}")
      end
    end
    image = doc.at_css(".img.img-responsive.img-roundedd")["src"]
    if image.chars.take(2).join == "//"
      uri = "https:#{image}"
    elsif image.chars.take(2).join == "/i"
      uri = "https://www.carjam.co.nz#{image}"
    else
      uri = image
    end
    if doc.at_css(".if-reported_stolen_location").to_s["Reported 1970-Jan-01"]
      infotext.push("Stolen: No")
    else
      infotext.push("Stolen: ***YES***")
    end
    event.channel.send_embed do |e|
      e.title = "CarJam Information for #{plate.upcase}"
      e.url = url+plate
      e.image = Discordrb::Webhooks::EmbedImage.new(url: uri.gsub(' ', '%20'))
      e.description = infotext.join("\n")
      e.color = '0000ff'
    end
  end
end
