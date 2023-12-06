#!/usr/bin/env ruby

race = STDIN.read.lines(chomp: true)
    .map{_1.match(/:(.*)/)[1].gsub(" ", "").to_i}

value = race[0]
    .times
    .filter{|n| (race[0] - n) * n > race[1]}
    .count

p(value)
