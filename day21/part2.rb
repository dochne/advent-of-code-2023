#!/usr/bin/env ruby --yjit

require "matrix"
require "rb_heap"
require "colorize"

CELL_COLOURS = [
    :red,
    :green,
    # :yellow,
    :blue,
    :magenta,
    # :white,
    # :default,
    :light_black,
    :light_red,
    :light_green,
    :light_yellow,
    :light_blue,
    :light_magenta,
    :light_cyan,
    :light_white,
    :grey,
]

input = STDIN.read.lines(chomp: true)
garden_height = input.size
garden_width = input[0].size

garden, start = input
    .each_with_index.reduce([{}, nil]) do |acc, (row, row_idx)|
    row.split("").each_with_index do |col, col_idx|
        if col == "#"
            acc[0][Vector[col_idx, row_idx]] = 1
        elsif col == "S"
            acc[1] = Vector[col_idx, row_idx]
        end 
    end
    acc
end

# garden[]
# def is_rock(garden, pos)
#     garden[pos ]
#     # garden % 
# end
# p(garden.keys.sort_by{[_1[1], _1[0]]})
# exit

heap = Heap.new { |a, b| a[1] < b[1] }
max_steps = 1000

heap << [start, 0]
visited = {start => 0}
valid = {start => 1}

while (current, steps = heap.pop) do
    # print("Visiting: ", current, ", Steps:", steps, "\n")
    [Vector[1,0], Vector[-1,0], Vector[0, 1], Vector[0, -1]].each do |direction|
        next_cell = current + direction
        next if valid[Vector[next_cell[0] % garden_width, next_cell[1] % garden_height]]
        next if garden[Vector[next_cell[0] % garden_width, next_cell[1] % garden_height]]
        valid[next_cell] = 1 if ((steps + 1) % 2) == 0
        heap << [next_cell, steps + 1] if steps + 1 < max_steps
    end
end

p(valid.keys.size)
