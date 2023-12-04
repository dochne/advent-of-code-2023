#!/usr/bin/env ruby
value = STDIN.read.lines(chomp: true)
    .map{_1.match(/^([^:]*):([^|]*)\|(.*)$/)}
    .map{[_1[2].split(" "), _1[3].split(" ")]}
    .map{ _1.intersection(_2).size }
    .map{ _1 + 1}
    .reverse
    .reduce [] do {|acc, total|
        acc << 1 + (total > 1 ? acc[-(total - 1)..].sum : 0)
    end
    .sum

p(value)
