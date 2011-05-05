#!/usr/bin/env ruby
# Formats output of 'verse' nicely.
verse = `verse`
ref = verse[Regexp.new('"  +(.*)$', Regexp::MULTILINE),1].to_s.strip
verse = verse.gsub(ref, "").strip
verse=verse.gsub(/  +/," ").gsub("\n","").scan(/.{1,33}/).
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

