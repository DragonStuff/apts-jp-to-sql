require 'rubygems'
require 'sinatra'
require 'sequel'
require 'json'


DB = Sequel.connect('sqlite://apartments.db') # requires sqlite3
items = DB[:items]