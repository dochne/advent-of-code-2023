#!/usr/bin/env ruby

#D 2 (#411b91)

require "matrix"
require "colorize"

DIRECTION_MAP = {"R" => Vector[1, 0], "L" => Vector[-1, 0], "U" => Vector[0, -1], "D" => Vector[0,1]}

def draw(nodes, extra)
    max_x = nodes.map{_1[0]}.max
    max_y = nodes.map{_1[1]}.max

    total = 0
    (max_y + 2).times do |y|
        (max_x + 2).times do |x|
            if extra.include? Vector[x, y]
                print("#".red)
            elsif nodes.include? Vector[x, y]
                total +=1
                print("#")
            else
                print(".")
            end
        end
        print("\n")
    end
    # p(total)
end

nodes = STDIN.read.lines(chomp: true)
    .map{ _1.scan /([A-Z]) (\d*) \(([^)]*)/ }
    .reduce([Vector[0, 0]]) do |vectors, ((direction, distance, colour)), |
        vectors << vectors.last + (distance.to_i * DIRECTION_MAP[direction])
    end
    .uniq
    .sort_by{[_1[1], _1[0]]}

total = 0
squares = []

print("Nodes ", nodes, "\n")

# draw(nodes, [])
before_nodes = nodes
while upper_left_node = nodes.shift
    upper_right_node = nodes.shift
    p("Nodes don't match", upper_left_node, upper_right_node) && exit if upper_left_node[1] != upper_right_node[1]

    row_nodes = nodes.filter{_1[1] == upper_left_node[1]}
    if (row_nodes.size % 2) == 1
        p(row_nodes)
        p("Shifting")
        upper_left_node = upper_right_node
        upper_right_node = nodes.shift
    end
    # print("UpperLeft ", upper_left_node, " UpperRight ", upper_right_node, "\n")
    # p(nodes)
    bottom_left_node = nodes.find{_1[0] == upper_left_node[0]}
    bottom_right_node = nodes.find{_1[0] == upper_right_node[0]}

    # p(highest_node, lowest_node)
    
    highest_node, lowest_node = [bottom_left_node, bottom_right_node].sort_by{[_1[1], _1[0]]}
    # print("Highest ", highest_node, " Lowest ", lowest_node, "\n")
    do_not_add_node = false
    if highest_node[1] == lowest_node[1]
        do_not_add_node = true
    #     p(highest_node, lowest_node)
    #     exit
    #     p("Exiting")
    #     # break
    #     # exit
    end

    nodes.delete(highest_node)

    new_node = Vector[lowest_node[0], highest_node[1]]

    size = ((upper_right_node[0] - upper_left_node[0])) * ((highest_node[1] - upper_left_node[1]))
    # next_node_on_highest = nodes.find{_1[1] == highest_node[1]}
    # size += next_node_on_highest[0] - highest_node[0] if next_node_on_highest
    # print("NextNodeOnHighest", next_node_on_highest)
    
    
    
    # total += size[0] * size[1]
    total += size

    if nodes.size == 1
        p("Breaking")
        break
    end
    if !do_not_add_node
        nodes << new_node 
    end

    print("Square ", upper_left_node, " ", upper_right_node, " ", bottom_left_node, " ", bottom_right_node, "- Size ", size, "\n")
    # print("NewNode", new_node, "\n")

    print(nodes.size, " Remain\n")
    # exit

    nodes.sort_by!{[_1[1], _1[0]]}
    print("Nodes ", nodes, "\n")
    draw(before_nodes, [upper_left_node, upper_right_node, highest_node, new_node])
    p("--")
    draw(nodes, [])
    before_nodes = nodes
end

p(total)

# end
# p(input)
exit

# offset_x, offset_y = input.reduce([0, 0]) do |(min_x, min_y), vector|
#     [[vector[0], min_x].min, [vector[1], min_y].min]
# end

# if offset_x != 0 || offset_y != 0
offset_vector = Vector[-offset_x + 1, -offset_y + 1]
# end

# max_x, max_y = input.reduce([0, 0]) do |(max_x, max_y), vector|
#     [[vector[0], max_x].max, [vector[1], max_y].max]
# end
