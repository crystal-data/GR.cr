# frozen_string_literal: true

require 'json'

paths = [
  File.expand_path('gr.json', __dir__)
  # File.expand_path('gr3.json', __dir__),
  # File.expand_path('grm.json', __dir__)
]

hash = {
  ':int' => 'Int32',
  ':double' => 'Float64',
  ':char' => 'Uint8'
}

b = []

paths.each do |path|
  data = JSON.parse(File.read(path))
  funcs = data.filter { |d| d['tag'] == 'function' }
  funcs.each do |f|
    print 'fun '
    print f['name']
    print '('
    f['parameters'].each_with_index do |prm, idx|
      idx.zero? || print(', ')
      print "a#{idx}"
      print ' : '
      if prm['type']['tag'] == ':pointer'
        b << prm['type']['tag'] if hash[prm['type']['type']['tag']].nil?
        print hash[prm['type']['type']['tag']]
        print '*'
      else
        print hash[prm['type']['tag']]
      end
      # p prm["type"]
    end
    print ')'
    puts
  end
end

p b.uniq
