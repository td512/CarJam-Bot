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
@bot = Discordrb::Commands::CommandBot.new token: ENV["DISCORD_BOT_TOKEN"], client_id: ENV["DISCORD_CLIENT_ID"], prefix: ENV["DISCORD_PREFIX"]

Dir["./plugins/*.rb"].each do |file|
  if ENV['DEBUG']
    puts "#{debug}Loading plugin #{file}"
  end
  require file
end
@ownerArray = [207572307928023040]
puts "#{info}Bot is now online. Invite URL is: #{@bot.invite_url}"

@bot.run
