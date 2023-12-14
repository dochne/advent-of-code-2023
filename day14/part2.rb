#!/usr/bin/env ruby

input = STDIN.read.lines(chomp: true)

height = input.size
width = input[0].size

grid = input.join.split("")

def shift(input, indexes)
    offset = 0
    indexes.each_with_index do |idx, dbg_idx|
        value = input[idx]
        if value == "."
            offset -= 1
        elsif value == "#"
            offset = 0
        elsif value == "O" && offset != 0
            input[indexes[dbg_idx + offset]] = value
            input[idx] = "."
        end
    end
end

def print_grid(grid, width)
    grid.each_slice(width).each do |row|
        print(row.join(""),"\n")
    end
end

column_list = width.times.map do |x|
    height.times.map {|y| (y * width) + x }
end
row_list = width.times.map { |x| ((x * width)...(x * width) + width).to_a}

start = Hash.new
n = 0
loop_found = false

until n == 1000000000
    if loop_found == false && !start[grid].nil?
        loop_length = n - start[grid]
        number_of_loops = ((1000000000 - n) / loop_length).floor
        n = n + number_of_loops * loop_length
        loop_found = true
    end
    start[grid] = n
    column_list.each { |list| shift(grid, list ) }
    # Move it left
    row_list.each { |list| shift(grid, list ) }
    # Move it down
    column_list.each { |list| shift(grid, list.reverse ) }
    # Move it right
    row_list.each { |list| shift(grid, list.reverse ) }
    n += 1
end

output = grid.each_slice(width)
value = output.each_with_index.reduce(0) do |acc, (row, index)|
    acc += row.filter{_1 == "O"}.size * (height - index)
end

p(value)
