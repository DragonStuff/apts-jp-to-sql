require 'json'
require 'net/http'
require 'uri'

def openthis(url)
    Net::HTTP.get(URI.parse(url))
end

# Get data from API and parse into object
api_url = "https://apts.jp/api/properties.json?rent_range[max]=150000&bedroom_range[min]=0&rent_range[min]="
puts api_url
response = openthis(api_url)
data = JSON.parse(response)

x = 0

while data['page']['current_page'].to_i != data['page']['total_pages'].to_i + 1
    data['properties'].each do |child|
        puts "Looking at property with ID " + child['id'].to_s + "..."
        x = x + 1
    end

    api_url = "https://apts.jp/api/properties.json?rent_range[max]=150000&bedroom_range[min]=0&rent_range[min]=" + "&page=" + (data['page']['current_page'] + 1).to_s
    response = openthis(api_url)
    data = JSON.parse(response)
end

puts "I expected " + data['page']['total_count'].to_s + " and the last one I looked at was " + x.to_s
if data['page']['total_count'].to_i == x
    puts "Everything seems to be in order."
else
    puts "Something is off..."
end

puts "Whoo! Finished processing properties."