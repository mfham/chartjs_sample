require 'csv'
require 'optparse'
require 'time'

opt = OptionParser.new
params = ARGV.getopts("i:")

raise StandardError, 'Please specify -i option' if params['i'].nil?

h_date = Hash.new {|h, k| h[k] = 0 }
h_person = Hash.new {|h, k| h[k] = 0 }

CSV.foreach("data/#{params['i']}", :headers => [:page_id, :yyyymmdd, :name]) do |row|
  yyyymm = Time.parse(row[:yyyymmdd]).strftime('%Y/%m')
  h_date[yyyymm] += 1
  h_person[row[:name]] += 1
end

arr_date = []
arr_person = []

h_date.keys.sort.each do |k|
  arr_date << {date: k, v: h_date[k]}
end
h_person.keys.sort.each do |k|
  arr_person << {name: k, v: h_person[k]}
end

puts arr_date.to_s.gsub(/=>/, ' ').gsub(/:(\w+)/) { $1 + ':' }
puts arr_person.to_s.gsub(/=>/, ' ').gsub(/:(\w+)/) { $1 + ':' }
