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

directions = STDIN.read.lines(chomp: true)
    .map{ _1.scan /([A-Z]) (\d*) \(([^)]*)/ }
    .map{ |((direction, distance, colour))| [direction, distance.to_i, colour]}

p(area_from_directions(directions))
exit
x = 0
y = 0
area = 0

# p(directions.first)
# exit
directions.each do |direction, distance, colour|
    # print("x ", x, " y ", y, " area ", area, "\n")
    distance -= 1
    case direction
    when 'R'
        x += distance
        area += distance * (y)
    when 'L'
        x -= distance
        area -= distance * (y)
    when 'U'
        y -= distance
    when 'D'
        y += distance
    end
    print("Direction: ", direction, " - Distance: ", distance, ": [x,y]: ", x,", ", y.to_s.rjust(2), " Area: ", area, "\n")
    # p(area)
end

area.abs

p(area)
exit
p(directions)
exit

    # .reduce([Vector[0, 0]]) do |vectors, ((direction, distance, colour)), |
    #     vectors << vectors.last + (distance.to_i * DIRECTION_MAP[direction])
    # end
    # .uniq
    # .sort_by{[_1[1], _1[0]]}


# nodes << nodes.first

# https://stackoverflow.com/questions/67114437/calculate-area-of-rectilinear-polygon-in-c
# sum = 0
# nodes.each_cons(2) do |(n1, n2))|
#     sum += n1[0]

# nodes = nodes.map{_1.to_f}
# nodes = nodes.map{Vector[_1[0] + 1000, _1[1] + 1000]}
# p(nodes)
# exit

# A=mb^2/(4*tan(pi/m))

# nodes.each do |row|
#     p(row)
# end
# exit
# nodes = [[4,10], [9,7], [11,2], [2,2], [4,10]]
# area = 0
# nodes.reverse.each_cons(2) do |(n1, n2)|
#     print("n1 ", n1, " n2 ", n2, "\n")
#     value = (n1[0] * n2[1]) - (n1[1] * n2[0])
#     p(value)
#     area += value
# end

# p(area.to_f / 2)
# exit



p(nodes)
exit

# offset_x, offset_y = nodes.reduce([0, 0]) do |(min_x, min_y), vector|
#     [[vector[0], min_x].min, [vector[1], min_y].min]
# end

# # p(offset_x, offset_y)
# offset_x = [0, offset_x].min.abs + 1
# offset_y = [0, offset_y].min.abs + 1

# # p(offset_x, offset_y)

# nodes = nodes.map{Vector[_1[0] + offset_x, _1[1] + offset_y]}
    
# p(area(nodes))

# # end
# # p(input)
# exit

# offset_x, offset_y = input.reduce([0, 0]) do |(min_x, min_y), vector|
#     [[vector[0], min_x].min, [vector[1], min_y].min]
# end

# if offset_x != 0 || offset_y != 0
# offset_vector = Vector[-offset_x + 1, -offset_y + 1]
# end

# max_x, max_y = input.reduce([0, 0]) do |(max_x, max_y), vector|
#     [[vector[0], max_x].max, [vector[1], max_y].max]
# end
