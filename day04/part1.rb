#!/usr/bin/env ruby

value = STDIN.read.lines(chomp: true)
    .map{_1.match(/^([^:]*):([^|]*)\|(.*)$/)}
    .map{[_1[2].split(" "), _1[3].split(" ")]}
    .map{ _1.intersection(_2).size }
    .map{ _1 > 0 ? 2 ** (_1-1) : 0 }
    .sum

p(value)
