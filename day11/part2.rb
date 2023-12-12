#!/usr/bin/env ruby

require "matrix"

OFFSET = 1000000 - 1

input = STDIN.read.lines(chomp: true)
    .map{_1.split("")}
    .yield_self do |grid|
        horizontal_rules = grid.each_with_index.reduce([]) do |acc, (line, idx)|
            next acc if !line.index("#").nil?
            acc << Proc.new {|vector| vector[1] > idx ? Vector[0, OFFSET] : Vector[0,0] }
        end

        vertical_rules = grid.transpose.each_with_index.reduce([]) do |acc, (line, idx)|
            next acc if !line.index("#").nil?
            acc << Proc.new {|vector| vector[0] > idx ? Vector[OFFSET, 0] : Vector[0,0] }
        end

        [grid, horizontal_rules + vertical_rules]
    end
    .yield_self do |grid, rules|
        vectors = grid.each_with_index.reduce([]) do |acc, (line, row_idx)|
            col_idx = -1
            while col_idx = line.join("").index("#", col_idx + 1)
                acc << Vector[col_idx, row_idx]
            end
            acc
        end
        [vectors, rules]
    end
    .yield_self do |vectors, rules|
        vectors.map do |vector|
            new_vec = vector.dup
            rules.each do |rule|
                new_vec += rule.call(vector)
            end
            new_vec
        end
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
