#!/usr/bin/env ruby

require "matrix"

input = STDIN.read.lines(chomp: true)
    .map{_1.split("")}
    .reduce([]) do |acc, line|
        acc << line if line.index("#").nil?
        acc << line
    end
    .transpose
    .reduce([]) do |acc, line|
        acc << line if line.index("#").nil?
        acc << line
    end
    .transpose
    .each_with_index.reduce([]) do |acc, (line, row_idx)|
        col_idx = -1
        while col_idx = line.join("").index("#", col_idx + 1)
            acc << Vector[row_idx, col_idx]
        end
        acc
    end

distances = input.reduce([]) do |acc, vector|
    input.each do |compare_vector|
        horizontal = [vector[0].abs, compare_vector[0].abs]
        vertical = [vector[1].abs, compare_vector[1].abs]
        acc << (horizontal.max - horizontal.min) + (vertical.max - vertical.min)
    end
    acc
end

p(distances.sum / 2)