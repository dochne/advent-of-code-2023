#!/usr/bin/env ruby

input = STDIN.read.lines(chomp: true)
    .first
    .split(",")
    .map do |step|
        step.split("").reduce(0) do |acc, char|
            (acc + char.ord) * 17 % 256
        end
    end

p(input.sum)