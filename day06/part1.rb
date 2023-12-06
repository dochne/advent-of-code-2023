#!/usr/bin/env ruby

race = Struct.new(:time, :distance)

input = STDIN.read.lines(chomp: true)
    .map{_1.gsub(/ +/, " ").split(" ")}
    
races = input[0].zip(input[1])[1..]
    .map{race.new(_1[0].to_i, _1[1].to_i)}

value = races.map do |race|
    race.time.times.filter{|n| (race.time - n) * n > race.distance}.count
end

p(value.reduce(&:*))
