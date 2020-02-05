@bot.command(:exit, help_available: false, chain_usable: false) do |event|
  break unless @ownerArray.include?(event.user.id) == true
  puts "#{info}Bot Shutdown"
  exit
end
