require 'sequel'

DB = Sequel.connect('sqlite://apartments.db')

apartments = DB[:apartments].where(rent: 0..130000, new: true)

file = File.open("found_properties.txt", "w")

apartments.each{|r| file.puts r[:url] }

file.close