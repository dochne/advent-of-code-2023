#!/usr/bin/env ruby

input = STDIN.read.lines(chomp: true)
    .first
    .split(",")
    .reduce(Hash.new) do |acc, step|
        _, label, operator, value = step.match(/^([^-=]*)([-=])(.*)$/).to_a
        box = label.split("").reduce(0) do |acc, char|
            (acc + char.ord) * 17 % 256
        end

        acc[box] = Hash.new if acc[box].nil?

        if operator == "="
            acc[box][label] = value.to_i
        else
            acc[box].delete(label)
        end

        acc
    end
    .each_pair.reduce(0) do |acc, (key, box)|
        acc += (key + 1) * (box.values.each_with_index.map {_1 * (_2 + 1)}.sum)
    end

p(input)
