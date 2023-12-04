#!/usr/bin/env ruby
value = STDIN.read.lines(chomp: true)
    .map{_1.match(/^([^:]*):([^|]*)\|(.*)$/)}
    .map{[_1[2].split(" "), _1[3].split(" ")]}
    .map{ _1.intersection(_2).size }
    .reverse
    .reduce([]) {|acc, total| acc << acc.last(total).sum + 1 }
    .sum

p(value)
