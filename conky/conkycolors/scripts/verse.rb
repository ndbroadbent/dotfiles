#!/usr/bin/env ruby
# Formats output of 'verse' nicely.
verse = `verse`
ref = verse[/"[\n ]+(.*)$/m,1].to_s.strip
verse = verse.gsub(ref, "").strip
verse = verse.gsub(/  +/," ").gsub("\n","").scan(/.{1,30}/).
        join("\n<br>").gsub(/([^ ]*)\n<br>/m,"\n"<<"\\1").strip
puts case ARGV.first
when "ref"; ref
when "verse"; verse
else "#{ref}\n#{verse}"
end

