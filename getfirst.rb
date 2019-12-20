require 'sequel'

DB = Sequel.connect('sqlite://apartments.db')

apartments = DB[:apartments].where(rent: 0..130000, new: true)

apartments.each{|r| p r[:property_id]}
