#!/usr/bin/env ruby

input = STDIN.read.lines(chomp: true)

seeds = input.shift
    .match(/:(.*)/).to_a[1]
    .strip
    .split
    .map(&:to_i)

rounds = input
    .join("\n").strip
    .gsub(" map:\n", ":")
    .split("\n\n")
    .map do |line|
        _, map_name, mappings = line.match(/([^:]*):(.*)/m).to_a
        ranges = mappings
            .split("\n")
            .map{_1.split.map(&:to_i)}
            .map{|dst, src, len|[Range.new(src, src + len), src, dst]}

        lambda do |n|
            ranges.each {|range, src, dst| return dst + (n - src) if range.include?(n)}
            n
        end
    end

value = seeds.map do |seed|
    rounds.reduce(seed) {|acc, round| acc = round.call(acc)}
end
.min

p(value)
