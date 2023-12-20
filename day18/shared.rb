def area(nodes)
    nodes = nodes.sort_by{[_1[1], _1[0]]}
    total = 0
    before_nodes = nodes

    while top_left_node = nodes.shift
        # print("=====================\n")
        top_right_node = nodes.shift
        p("Nodes don't match", top_left_node, top_right_node) && exit if top_left_node[1] != top_right_node[1]

        potential_bottom_left_node = nodes.find{_1[0] == top_left_node[0]}
        potential_bottom_right_node = nodes.find{_1[0] == top_right_node[0]}

        # The node's of the bottom_left and bottom_right that are highest up in the grid
        top_node, bottom_node = [potential_bottom_left_node, potential_bottom_right_node].sort_by{_1[1]}

        if top_node == potential_bottom_left_node
            bottom_left_node = potential_bottom_left_node
            # It's worth noting, that bottom_right_node can still be equal to potential_bottom_right_node here
            bottom_right_node = Vector[top_right_node[0], top_node[1]]
        else
            bottom_left_node = Vector[top_left_node[0], top_node[1]]
            bottom_right_node = potential_bottom_right_node
        end

        # prev_total = total

        size_vector = (bottom_right_node - top_left_node)
        size = (size_vector[0] + 1) * (size_vector[1])
        total += size

        if nodes.size == 2 && potential_bottom_left_node == bottom_left_node && potential_bottom_right_node == bottom_right_node
            return total + (bottom_right_node[0] - bottom_left_node[0]) + 1
        end

        # should be 34329

        # prev_total = total
        bottom_nodes = nodes.filter{_1[1] == bottom_left_node[1]}
        
        offset = 0
        if bottom_left_node == potential_bottom_left_node
            if (index = bottom_nodes.index(bottom_left_node)) % 2 == 0
                offset += bottom_nodes[index + 1][0] - bottom_left_node[0]
            end
            nodes.delete(bottom_left_node)
        else
            nodes << bottom_left_node
        end

        if bottom_right_node == potential_bottom_right_node
            if (index = bottom_nodes.index(bottom_right_node)) % 2 == 1
                offset += bottom_right_node[0] - bottom_nodes[index - 1][0]
            end
            nodes.delete(bottom_right_node)
        else
            nodes << bottom_right_node
        end

        total += offset
        # print("Square ", top_left_node, " ", top_right_node, " ", bottom_left_node, " ", bottom_right_node, "- Size ", size, "\n")
        # print("Size of Square: ", size, ", Adjustment: ", offset, ", Vector: ", size_vector, ", New Total: ", total, ", Remaining:", nodes.size, "\n")

        # if nodes.size == 1
        #     p("Breaking")
        #     break
        # end

        # if nodes.size == 0
        #   total += 1
        # end
        nodes.sort_by!{[_1[1], _1[0]]}
    end

    total
end