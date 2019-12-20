require 'sequel'
require 'json'
require 'net/http'
require 'uri'
require 'bigdecimal'

DB = Sequel.connect('sqlite://apartments.db') # requires sqlite3

apartments = DB[:apartments] # Create a dataset

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
        print "Looking at property with ID " + child['id'].to_s + "... "
        if !apartments.where(property_id: child['id'].to_i)
                x = x + 1
                apartments.insert(
                    property_id: child['id'].to_i,
                    kind: child['kind'].to_s,
                    building_name: child['building_name'].to_s,
                    prefecture: child['prefecture'].to_s,
                    city: child['city'].to_s,
                    address1: child['address1'].to_s,
                    address2: child['address2'].to_s,
                    lat: BigDecimal(child['lat'], 7),
                    lng: BigDecimal(child['lng'], 8),
                    distance_in_minute: child['building_station']['distance_in_minute'].to_i,
                    rent: child['room']['rent'].delete(',').to_i,
                    url: child['room']['url'].to_s,
                    image_url: child['room']['image_url'].to_s,
                    new: !!child['room']['new'],
                    features: child['room']['features'].to_s,
                    bedroom: child['bedroom'].to_s,
                    bath: child['bath'].to_s,
                    area: child['area'].to_s,
                )
            puts "done."
        else
            puts "looks like I already have this one."
        end
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