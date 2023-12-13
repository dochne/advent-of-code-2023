#!/usr/bin/env ruby

# https://www.utf8-chartable.de/unicode-utf8-table.pl?start=9472&number=128&names=-&utf8=string-literal

require "matrix"
require "colorize"

input = STDIN.read.lines(chomp: true)
output = input.map {_1.split("") }
wall_grid = input.map {_1.split("").map{0} }

# walk before you climb
DIRECTIONS = {
    "|" => [Vector[0, 1], Vector[0, -1]],
    "-" => [Vector[1, 0], Vector[-1, 0]],
    "L" => [Vector[0, -1], Vector[1, 0]],
    "J" => [Vector[0, -1], Vector[-1, 0]],
    "7" => [Vector[-1, 0], Vector[0, 1]],
    "F" => [Vector[1, 0], Vector[0, 1]]
}

# We can add together the vector values as a sum 
# | = +1 vertical
# - = +1 horizontal
# L/J/7/F = +1 horizontal, +1 vertical - but only if relevant

start = nil
input.each_with_index do |row, row_index|
    if start.nil?
        s_pos = row.index("S")
        start = Vector[s_pos, row_index] if !s_pos.nil?
        # p(output[0]])
        # exit
        output[s_pos][row_index] = output[s_pos][row_index].red if !s_pos.nil?
    end
end

if start.nil?
    print "Start is nil", "\n"
    exit
end

p("Start", start)
p("START")

start_dir = nil
# [Vector[1, 0], Vector[-1, 0], Vector[0, 1], Vector[0, -1]].each do |direction|
#     break if !start_dir.nil?
#     DIRECTIONS.each do |symbol, dirs|
#         if dirs.any?{ start + direction + _1 == start }
#             start_dir = direction
#             break
#         end
#     end
# end

# Hard coding as one vertical down
start_dir = Vector[0, 1]

i = 0
wall_grid[start[1]][start[0]] = Vector[0, 1]
next_dir = start_dir
position = start
p("Start Position", start)
loop {
    position += next_dir
    i+=1

    if position == start
        break
    end

    value = input[position[1]][position[0]]
    output[position[1]][position[0]] = value.green

    wall_grid[position[1]][position[0]] = DIRECTIONS[value].first
    last_dir = next_dir
    if !DIRECTIONS.has_key? value
        print("No direction information known for ", value, "\n")
        exit
    end
    next_dir = DIRECTIONS[value].filter{_1 != next_dir * -1}[0]
}

total = 0
wall_grid.each_with_index do |row, row_index|
    row.each_with_index do |value, col_index|
        if value != 0
            next
        end

        left_sum = row[0...col_index].filter{_1 != 0}.map{_1[1]}.sum
        if (left_sum % 2 > 0)
            total += 1
            output[row_index][col_index] = (left_sum > 10 ? "-" : left_sum % 10).to_s.blue
        else
            output[row_index][col_index] = (left_sum > 10 ? "-" : left_sum % 10)
        end
    end
end

output.map{
    _1.join("")
        .gsub("|", "\u2551")
        .gsub("-", "\u2550")
        .gsub("L", "\u255A")
        .gsub("J", "\u255D")
        .gsub("7", "\u2557")
        .gsub("F", "\u2554")
        .gsub("S", "S".red)
}.each_with_index do |line, idx|
    puts(line.encode('utf-8'))
end

p(total)
