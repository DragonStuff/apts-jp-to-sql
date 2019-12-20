require 'sequel'

DB = Sequel.connect('sqlite://apartments.db')

apartments = DB[:apartments].where(rent: 0..130000, new: true)

file = File.open("found_properties.txt", "w")

time = Time.new

file.puts "---"
file.puts "title: Update - " + time.day.to_s + "-" + time.month.to_s + "-" + time.year.to_s
file.puts "assignees: DragonStuff"
file.puts "labels: bug, enhancement"
file.puts "---"

apartments.each{|r| file.puts r[:url] }

file.close