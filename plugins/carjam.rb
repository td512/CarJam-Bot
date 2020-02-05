require 'nokogiri'
require 'open-uri'
url = "https://www.carjam.co.nz/car/?plate="
attributes = %w(year_of_manufacture make model main_colour body_style engine_number cc_rating fuel_type)
str = %w(Year: Make: Model: Colour: Body\ Style: Engine\ Serial: CC\ Rating: Fuel\ Type:)
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
  doc = Nokogiri::HTML(open(url+plate))
  infotext.clear
  attributes.each_with_index do |attrib, index|
    doc.css("[data-key=#{attrib}] + .value").each do |item|
        infotext.push("#{str[index]} #{item.inner_html.strip.gsub('<span class="terminal">', '').gsub(/(<[^>]*>)|\n|\t/s) {" "}}")
    end
  end
  event.channel.send_embed do |e|
    e.title = "CarJam Information for #{plate}"
    e.description = infotext.join("\n")
    e.color = '0000ff'
  end
end
