#!/usr/bin/env ruby

#D 2 (#411b91)

require "matrix"
require "colorize"

DIRECTION_MAP = {"R" => Vector[1, 0], "L" => Vector[-1, 0], "U" => Vector[0, -1], "D" => Vector[0,1]}

def draw(nodes, extra)
    # p(extra)
    tmp = nodes + extra
    max_x = tmp.map{_1[0]}.max
    max_y = tmp.map{_1[1]}.max

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
# exit
before_nodes = nodes
while top_left_node = nodes.shift
    print("=====================\n")
    top_right_node = nodes.shift
    p("Nodes don't match", top_left_node, top_right_node) && exit if top_left_node[1] != top_right_node[1]

    # upper_nodes = nodes.filter{_1[1] == top_left_node[1]}

    potential_bottom_left_node = nodes.find{_1[0] == top_left_node[0]}
    potential_bottom_right_node = nodes.find{_1[0] == top_right_node[0]}

    # The node's of the bottom_left and bottom_right that are highest up in the grid
    top_node, bottom_node = [potential_bottom_left_node, potential_bottom_right_node].sort_by{[_1[1], _1[0]]}

    if top_node == potential_bottom_left_node
        bottom_left_node = potential_bottom_left_node
        # It's worth noting, that bottom_right_node can still be equal to potential_bottom_right_node here
        bottom_right_node = Vector[bottom_node[0], top_node[1]]
    else
        bottom_left_node = Vector[bottom_node[0], top_node[1]]
        bottom_right_node = potential_bottom_right_node
    end

    prev_total = total
    if nodes.size == 2 && potential_bottom_left_node == bottom_left_node && potential_bottom_right_node == bottom_right_node
       total += (bottom_right_node[0] - bottom_left_node[0])
       nodes = []
    else

        
        # ZERRO INDEXED!
        bottom_nodes = nodes.filter{_1[1] == bottom_left_node[1]}
        print("BottomNodes ", bottom_nodes, "\n")
        if bottom_left_node == potential_bottom_left_node
            # Then it was at the top!
            if (index = bottom_nodes.index(bottom_left_node)) % 2 == 1
                # Then we delete this node, and we add next_node - 1
                # total += bottom_left_node[0] - bottom_nodes[index - 1][0]
            else
                # p("Path1")
                total += bottom_nodes[index + 1][0] - bottom_left_node[0]
            end
            nodes.delete(bottom_left_node)
            # bottom_nodes.delete_at(index)
        else
            nodes << bottom_left_node
        end

        # Pay attention to the prev node I guess
        # bottom_nodes = nodes.filter{_1[1] == bottom_left_node[1]}

        # What happens if the bottom_right_node is the *first* node 
        if bottom_right_node == potential_bottom_right_node
            # Then it was at the top!
            p("Index", bottom_nodes.index(bottom_right_node))
            if (index = bottom_nodes.index(bottom_right_node)) % 2 == 1
                # Then we delete this node, and we add next_node - 1

                # print("BottomLeft: ", bottom_left_node, ", BottomRight: ", bottom_right_node, ", PotentialLeft: ", potential_bottom_left_node, "PotentialRight: ", potential_bottom_right_node, "\n")
                print("BottomNodes ", bottom_nodes, "\n")
                p("Path2", bottom_right_node, bottom_nodes[index - 1])
                total += bottom_right_node[0] - bottom_nodes[index - 1][0]
                # total += bottom_right_node[0] - bottom_nodes[index + 1][0]
            else
                # total += bottom_nodes[index + 1][0] - bottom_right_node[0]
            end
            nodes.delete(bottom_right_node)
            bottom_nodes.delete_at(index)
        else
            nodes << bottom_right_node
        end
    end

    additional_added = 0
    additional_added = total - prev_total if total != prev_total


    size_vector = (bottom_right_node - top_left_node)
    size = (size_vector[0] + 1) * (size_vector[1])
    # p(size_vector)
    # highest_node, lowest_node = [bottom_left_node, bottom_right_node].sort_by{[_1[1], _1[0]]}

    # nodes.delete(highest_node)

    # new_node = Vector[lowest_node[0], highest_node[1]]

    # size = ((upper_right_node[0] - upper_left_node[0])) * ((highest_node[1] - upper_left_node[1]))
    # next_node_on_highest = nodes.find{_1[1] == highest_node[1]}
    # size += next_node_on_highest[0] - highest_node[0] if next_node_on_highest
    # print("NextNodeOnHighest", next_node_on_highest)
    
    
    
    # total += size[0] * size[1]
    total += size
    print("Square ", top_left_node, " ", top_right_node, " ", bottom_left_node, " ", bottom_right_node, "- Size ", size, "\n")
    print("Size of Square: ", size, ", Adjustment: ", additional_added, ", Vector: ", size_vector, ", New Total: ", total, ", Remaining:", nodes.size, "\n")

    if nodes.size == 1
        p("Breaking")
        break
    end

    if nodes.size == 0
        total += 1
    end
    # print("Square ", top_left_node, " ", top_right_node, " ", bottom_left_node, " ", bottom_right_node, "- Size ", size, "\n")
    # print("NewNode", new_node, "\n")

    # print(nodes.size, " Remain\n")
    # exit

    nodes.sort_by!{[_1[1], _1[0]]}
    # print("Nodes ", nodes, "\n")
    # print("Size: ", size, "\n")
    
    # draw(before_nodes, [top_left_node, top_right_node, bottom_left_node, bottom_right_node])
    # p("--")
    # draw(nodes, [])
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
