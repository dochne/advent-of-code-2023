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

garden, start = STDIN.read.lines(chomp: true)
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

# p(garden.keys.sort_by{[_1[1], _1[0]]})
# exit

heap = Heap.new { |a, b| a[1] < b[1] }
max_steps = 64

heap << [start, 0]
visited = {start => 0}
valid = {start => 1}

# Probs use heap ordered by min number
while (current, steps = heap.pop) do
    # p(steps)
    # print("Visiting: ", current, ", Steps:", steps, "\n")
    [Vector[1,0], Vector[-1,0], Vector[0, 1], Vector[0, -1]].each do |direction|
        next_cell = current + direction
        # next if visited[next_cell] && visited[next_cell] > steps + 1
        next if valid[next_cell]
        next if garden[next_cell]
        # next if visited[next_cell] && visited[next_cell] % 2 == 0
        valid[next_cell] = 1 if ((steps + 1) % 2) == 0
        # visited[next_cell] = (steps + 1 == 
        # next if (steps + 1 % 2) == 0
        heap << [next_cell, steps + 1] if steps + 1 < max_steps
    end
end

p(valid.keys.size)
# p(garden.map{_1})
# exit

# min_x, max_x = garden.keys.map{_1[0]}.minmax
# min_y, max_y = garden.keys.map{_1[1]}.minmax

# (max_y + 2).times do |row_idx|
#     (max_x + 2).times do |col_idx|
#         cell = Vector[col_idx, row_idx]
#         if garden[cell]
#             print("#")
#         elsif visited[cell]
#             print(visited[cell].to_s.colorize(CELL_COLOURS[visited[cell] % CELL_COLOURS.size]))
#         else
#             print(".")
#         end
#     end
#     print("\n")
# end


# p(visited.filter{|k, v| v == 6}.size)
# p(visited.size)

exit
