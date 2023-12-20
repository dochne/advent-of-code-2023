#!/usr/bin/env ruby

#D 2 (#411b91)
require "json"
require "matrix"
require "colorize"

part2_method_data = 
part2_map = {}
JSON.parse(File.read("day18/part2.json")).each do |x, y|
    part2_map[Vector[x, y]] = [x, y]
end

input = STDIN.read.lines(chomp: true)
    .map{ _1.scan /([A-Z]) (\d*) \(([^)]*)/ }
    .reduce([Hash.new, Vector[0, 0]]) do |(grid, pos), ((direction, distance, colour)), |
        dir_vector = case direction
        when "R"
            Vector[1, 0]
        when "L"    
            Vector[-1, 0]
        when "U"
            Vector[0, -1]
        when "D"
            Vector[0, 1]
        end
        1.upto(distance.to_i) do |dist|
            grid[pos + (dist * dir_vector)] = dir_vector
        end

        [grid, pos + (distance.to_i * dir_vector)]
    end.first

offset_x, offset_y = input.keys.reduce([0, 0]) do |(min_x, min_y), vector|
    [[vector[0], min_x].min, [vector[1], min_y].min]
end

# if offset_x != 0 || offset_y != 0
offset_vector = Vector[-offset_x + 1, -offset_y + 1]
input = input.map{ [_1 + offset_vector, _2]}.to_h
# end

max_x, max_y = input.keys.reduce([0, 0]) do |(max_x, max_y), vector|
    [[vector[0], max_x].max, [vector[1], max_y].max]
end


# output = input
stack = [input.first[0] + Vector[1,1]]
while vector = stack.pop
    next if !input[vector].nil?  #!input[vector].nil?
    input[vector] = 1
    [Vector[-1, 0], Vector[1, 0], Vector[0, 1], Vector[0, -1]].each do |dir|
        stack << vector + dir
    end
end



total = 0

print(" ")
(max_x + 2).times do |x|
    v1 = x % 10
    print(v1 == 0 ? v1.to_s.red : v1)
    # print(x % 10 == 0 ?x % 10)
end
print("\n")

(max_y + 2).times do |y|
    # in_cell = 0
    # total_in_row = 0
    # (max_x + 2).times do |x|
    #     total_in_row += input[Vector[x, y]][1] if input[Vector[x, y]]
    # end

    # print(total_in_row, " - ")
    v1 = y % 10
    print(v1 == 0 ? v1.to_s.red : v1)

    (max_x + 2).times do |x|
        if input[Vector[x, y]]
            # in_cell += input[Vector[x, y]][1]
            # in_hole +=1
            total +=1
            print(part2_map[Vector[x, y]] ? "#".green : "#")
        elsif part2_map[Vector[x, y]]
            print("$".red)
        else
            # exit
            # if in_cell % 2 == 1 && in_cell != total_in_row
            #     total +=1
            #     print("#")
            # else
                # print(in_cell)
            print(".")
            # end
        end
    end
    print("\n")
end
p(total)
# 30538 too low
# 38970 too high