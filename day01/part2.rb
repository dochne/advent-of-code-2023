#!/usr/bin/env ruby

REPLACEMENTS = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

def numerate(value)
    REPLACEMENTS.each_with_index.reduce(value) {|acc, (number, index)| acc.gsub(number, (index + 1).to_s) }
end

result = STDIN.read.split("\n")
    .map{|string| [
        /\d|#{REPLACEMENTS.join("|")}/.match(string)[0],
        /\d|#{REPLACEMENTS.map{_1.reverse}.join("|")}/.match(string.reverse)[0].reverse
    ]}
    .map{(numerate(_1) + numerate(_2)).to_i}
    .sum

p(result)