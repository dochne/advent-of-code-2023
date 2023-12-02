#!/usr/bin/env ruby


value = STDIN.read.lines(chomp: true)
    .map{_1.match(/Game (\d*): (.*)/)}
    .map{[_1[1].to_i, _1[2].split("; ").map{|round| round.split(", ")}]}
    .map do |game, rounds|
        rounds.each_with_object Hash.new do |value, obj|
            value.each do
                total, color = _1.split(" ")
                obj[color] = obj.has_key?(color) ? [total.to_i, obj[color]].max : total.to_i
            end
        end
    end
    .map{_1.values.reduce(:*)}
    .sum
p(value)
