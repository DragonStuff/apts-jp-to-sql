require 'sequel'

DB = Sequel.connect('sqlite://apartments.db') # requires sqlite3

apartments = DB[:apartments].where(rent: 0..110000, city: "Shibuya-ku") # Read a dataset

puts apartments.first
