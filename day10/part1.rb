#!/usr/bin/env ruby

# https://www.utf8-chartable.de/unicode-utf8-table.pl?start=9472&number=128&names=-&utf8=string-literal

require "matrix"
require "colorize"

input = STDIN.read.lines(chomp: true)
output = input.map {_1.split("") }
# p(output)
# exit
    #.map{_1.split("")}

# walk before you climb
DIRECTIONS = {
    "|" => [Vector[0, 1], Vector[0, -1]],
    "-" => [Vector[1, 0], Vector[-1, 0]],
    "L" => [Vector[0, -1], Vector[1, 0]],
    "J" => [Vector[0, -1], Vector[-1, 0]],
    "7" => [Vector[-1, 0], Vector[0, 1]],
    "F" => [Vector[1, 0], Vector[0, 1]]
}

p("HELL")

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


# start = input.each_with_index.reduce(nil) do |acc, (row, index)|
#     print("acc", acc, " - ", row, " - ", index, "\n")
#     # acc = "hat"
#     if acc.nil? && !(s_pos = row.index("S")).nil?
#         return Vector[s_pos, index]
#     end
#     # p("Returning", acc)
#     acc
# end

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
start_dir = Vector[0, 1]

# print("Start", start, "StarDir", start_dir, "\n")

# exit
i = 0
next_dir = start_dir
position = start
p("Start Position", start)
loop {
    # print "Position ", position, " NextDir ", next_dir, "\n"
    print("Applying ", next_dir, "\n")
    position += next_dir
    i+=1

    if position == start
        print "YAYAYAY", "\n"
        p("Position", position)
        p("StartPosition", start)
        print i / 2
        print "\n"
        break
        # exit
    end

    value = input[position[1]][position[0]]
    p("VALUUE", value)
    output[position[1]][position[0]] = value.green
    # input[position[1]][position[0]] = value.green
    # p("Input", input)
    # p(position)
    # p("Value", value)
    last_dir = next_dir
    if !DIRECTIONS.has_key? value
        print("No direction information known for ", value, "\n")
        exit
    end
    next_dir = DIRECTIONS[value].filter{_1 != next_dir * -1}[0]
    print(
        "Position is ",
        position,
        " Value is ",
        value,
        " LastDir is ",
        last_dir,
        " NextDirection is ",
        next_dir,
        " Inverted is ",
        last_dir * -1,
        " - options:",
        DIRECTIONS[value],
        "\n"
    )
}

# p(matrix.element(0, 1))
# p(Vector[0, 1].to_a)
# p(matrix[Vector[0, 1].to_a])
# p(matrix[0, 1])
# p(matrix[Vector[0, 0]])
# p(matrix)


# p(DIRECTIONS)
# exit

p("INPUT SIZZE", input.size)

# input.each do |line|
#     print(line)
# end
# exit
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
# p(DIRECTIONS)
# exit
# value

# | is a vertical pipe connecting north and south.
# - is a horizontal pipe connecting east and west.
# L is a 90-degree bend connecting north and east.
# J is a 90-degree bend connecting north and west.
# 7 is a 90-degree bend connecting south and west.
# F is a 90-degree bend connecting south and east.
# . is ground; there is no pipe in this tile.
# S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.