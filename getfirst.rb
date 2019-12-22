require 'sequel'
require 'json'
require 'net/http'
require 'uri'

DB = Sequel.connect('sqlite://apartments.db')

def openthis(url)
    Net::HTTP.get(URI.parse(url))
end

apartments = DB[:apartments].where(rent: 0..130000, new: true)

if apartments.first
    file = File.open("found_properties.txt", "w")

    time = Time.new

    file.puts "---"
    file.puts "title: Update - " + time.day.to_s + "-" + time.month.to_s + "-" + time.year.to_s
    file.puts "assignees: DragonStuff"
    file.puts "labels: enhancement"
    file.puts "---"

    apartments.each{ |r| 
        response = openthis(r[:url])

        file.puts "---"
        file.puts "- [ ] " + r[:url]
        if response.include? "Conversational Japanese"
            file.puts "🛑 JAPANESE REQUIRED."
        end
        file.puts r[:features]
    }

    file.puts "---"
    file.close
else
    puts "Nothing new to look at."
end