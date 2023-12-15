#!/usr/bin/env ruby

input = STDIN.read.lines(chomp: true)
    .first
    .split(",")
    .each_with_object(Hash.new {|h, k| h[k] = {}}) do |step, acc|
        _, label, operator, length = step.match(/^([^-=]*)([-=])(.*)$/).to_a
        box = acc[label.split("").reduce(0) { |acc, char| (acc + char.ord) * 17 % 256 }]
        if operator == "="
            next box[label] = length.to_i
        end
        box.delete(label)
    end
    .each_pair.reduce(0) do |acc, (key, box)|
        acc += (key + 1) * (box.values.each_with_index.map {_1 * (_2 + 1)}.sum)
    end

p(input)
