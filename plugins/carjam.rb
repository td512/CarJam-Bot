require 'nokogiri'
require 'open-uri'
url = "https://www.carjam.co.nz/car/?plate="
attributes = %w(Year: Make: Model: Submodel: Colour: Body\ Style: Engine\ Serial: CC\ Rating: Fuel\ Type:)
key_array = Array.new
value_array = Array.new
infotext = Array.new

@bot.command(:carjam, help_available: false, chain_usable: true) do |event, *text|
  text = text.join('').upcase
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
    key_array.clear
    value_array.clear
    infotext.clear

    doc.css("span.key").each do |item|
      key_array.push(item.inner_html.strip.gsub('<span class="terminal">', '').gsub(/(<[^>]*>)|\n|\t/s) {" "})
    end
    doc.css("span.value").each do |item|
      value_array.push(item.inner_html.strip.gsub('<span class="terminal">', '').gsub(/(<[^>]*>)|\n|\t/s) {" "})
    end

    image = doc.at_css(".img.img-responsive.img-roundedd")["src"]
    if image.chars.take(2).join == "//"
      uri = "https:#{image}"
    elsif image.chars.take(2).join == "/i"
      uri = "https://www.carjam.co.nz#{image}"
    else
      uri = image
    end
    key_array.each_with_index do |key, _|
      next unless attributes.include? key
      infotext.push("#{key} #{value_array[_]}")
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
