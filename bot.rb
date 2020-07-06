$VERBOSE=nil
# Discord Ruby Bindings
@start_time = Time.now
require 'discordrb'
require './colors.rb'
def info
  return colorize("[INFO] ", "green")
end
def warning
  return colorize("[WARNING] ", "yellow")
end
def error
  return colorize("[ERROR] ", "red")
end
def debug
  return colorize("[DEBUG] ", "blue")
end
Discordrb::LOGGER.mode = :silent
# Insert your Client ID and token here
@bot = Discordrb::Commands::CommandBot.new token: '', client_id: 000000000000000000, prefix: '!'

Dir["./plugins/*.rb"].each do |file|
  if ENV['DBG'] == "yes"
    puts "#{debug}Loading plugin #{file}"
  end
  require file
end
parent = ENV['PARENT']
@ownerArray = [207572307928023040]
puts "#{info}Bot is now online. Invite URL is: #{@bot.invite_url}"

@bot.run
