#!/usr/bin/env ruby


value = STDIN.read.lines(chomp: true)
    .map{_1.match(/Game (\d*): (.*)/)}
    .map{[_1[1].to_i, _1[2].split("; ").map{|round| round.split(", ")}]}
    .map do |game, rounds|
        rounds.each_with_object Hash.new do |value, obj|
            value.each do |color|
                split = color.split(" ")
                if obj.has_key?(split[1])
                    obj[split[1]] = [split[0].to_i, (obj[split[1]]).to_i].max
                else
                    obj[split[1]] = split[0].to_i
                end
            end
        end
    end
    .map{_1.values.reduce(:*)}
    .sum
p(value)
