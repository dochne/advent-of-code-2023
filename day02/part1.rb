#!/usr/bin/env ruby


value = STDIN.read.lines(chomp: true)
    .map{_1.match(/Game (\d*): (.*)/)}
    .map{[_1[1].to_i, _1[2].split("; ").map{|round| round.split(", ")}]}
    .map{p(_1)}
    .map do |game, rounds|
        max_dice_usage = rounds.each_with_object Hash.new do |value, obj|
            value.each do |color|
                split = color.split(" ")
                obj[split[1]] = [split[0].to_i, (obj[split[1]] || 0).to_i].max
            end
        end
        [game, max_dice_usage]
    end
    .filter{_2["red"] <=12 && _2["green"] <= 13 && _2["blue"] <= 14}
    .map{ _1[0] }
    .sum



p(value)
# op = line.match(/= ([^ ]*) (.) ([^ ]*)/).to_a.drop(1)
