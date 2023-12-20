#!/usr/bin/env ruby

require "matrix"
require "colorize"
require_relative "shared"

DIRECTION_MAP = {"R" => Vector[1, 0], "L" => Vector[-1, 0], "U" => Vector[0, -1], "D" => Vector[0,1]}

# def draw(nodes, extra)
#     # p(extra)
#     tmp = nodes + extra
#     max_x = tmp.map{_1[0]}.max
#     max_y = tmp.map{_1[1]}.max

#     total = 0
#     (max_y + 2).times do |y|
#         (max_x + 2).times do |x|
#             if extra.include? Vector[x, y]
#                 print("#".red)
#             elsif nodes.include? Vector[x, y]
#                 total +=1
#                 print("#")
#             else
#                 print(".")
#             end
#         end
#         print("\n")
#     end
#     # p(total)
# end

nodes = STDIN.read.lines(chomp: true)
    .map{ _1.scan /([A-Z]) (\d*) \(([^)]*)/ }
    .reduce([Vector[0, 0]]) do |vectors, ((direction, distance, colour)), |
        vectors << vectors.last + (distance.to_i * DIRECTION_MAP[direction])
    end
    .uniq
    .sort_by{[_1[1], _1[0]]}

offset_x, offset_y = nodes.reduce([0, 0]) do |(min_x, min_y), vector|
    [[vector[0], min_x].min, [vector[1], min_y].min]
end

# p(offset_x, offset_y)
offset_x = [0, offset_x].min.abs + 1
offset_y = [0, offset_y].min.abs + 1

# p(offset_x, offset_y)

nodes = nodes.map{Vector[_1[0] + offset_x, _1[1] + offset_y]}
    
p(area(nodes))

# end
# p(input)
exit

# offset_x, offset_y = input.reduce([0, 0]) do |(min_x, min_y), vector|
#     [[vector[0], min_x].min, [vector[1], min_y].min]
# end

# if offset_x != 0 || offset_y != 0
# offset_vector = Vector[-offset_x + 1, -offset_y + 1]
# end

# max_x, max_y = input.reduce([0, 0]) do |(max_x, max_y), vector|
#     [[vector[0], max_x].max, [vector[1], max_y].max]
# end
