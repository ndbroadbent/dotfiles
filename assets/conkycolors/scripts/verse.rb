#!/usr/bin/env ruby
# Formats output of 'verse' nicely.
verse,ref=`verse`.split(/ {11}+/)
verse=verse.gsub(/  +/," ").gsub("\n","").scan(/.{1,29}/).
  join("\n<br>").gsub(/([^ ]*)\n<br>/m,"\n"<<"\\1").strip
ref=ref.strip
case ARGV.first
when "ref"
  puts ref
when "verse"
  puts verse
else
  puts "#{verse}\n#{ref}"
end

