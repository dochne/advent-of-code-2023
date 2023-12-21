require 'json'
require 'colorize'

# DIRECTION_MAP = {"R" => Vector[1, 0], "L" => Vector[-1, 0], "U" => Vector[0, -1], "D" => Vector[0,1]}

SQUARE_COLORS = [
    # :red,
    :green,
    :yellow,
    :blue,
    # :magenta,
    # :white,
    # :default,
    :light_black,
    # :light_red,
    :light_green,
    :light_yellow,
    :light_blue,
    # :light_magenta,
    :light_cyan,
    # :light_white,
    :grey,
]

def draw(red, before_nodes = [])
    # p(extra)
    tmp = red + before_nodes.map{_1[0]}

    min_x = tmp.map{_1[0]}.min
    min_y = tmp.map{_1[1]}.min

    # p("MinX", min_x)
    # p("MinY", min_y)
    # exit
    max_x = tmp.map{_1[0]}.max
    max_y = tmp.map{_1[1]}.max

    # red_mapped = red.map{[_1[0], _1[1]]}
    mapped = {}
    before_node_map = {}
    red.each do |n|
        mapped[Vector[n[0], n[1]]] = n
    end

    before_nodes.each do |n, text|
        before_node_map[Vector[n[0], n[1]]] = text
    end
    # p(before_node_map)
    # exit

    total = 0
    (max_y + 2).times do |y|
        (max_x + 2).times do |x|
            before_node = before_node_map[Vector[x, y]]
            node = mapped[Vector[x, y]]# red.find{|n| n[0] == x && n[1] == y}
            
            if before_node && node
                print(before_node.red)
            elsif before_node
                print(before_node.red)
                # p("Fubar")
                # exit
                # print("$".red)
            elsif node && node[2]
                print("#".colorize(node[2]))
            elsif node
                print("#".yellow)
            # if red_mapped.include ? [x, y]
            #     red_mapped.
            # if red.include? [x, y]
            #     print("#".red)
            # elsif green.include? [x, y]
            #     print("#".green)
            else
                print(".")
            end
        end
        print("\n")
    end
    # p(total)
end

def area_from_directions(directions)

    x = 0
    y = 0
    area = 0

    # p("Directions", directions)
    # exit

    # p(directions.first)
    # exit
    vertical_side = :TOP_SIDE
    horizontal_side = :LEFT_SIDE

    total_travelled = 0
    directions.each_with_index do |(direction, distance), idx|

        next_direction, _ = directions[idx % directions.size + 1]

        # p(direction)
        # exit

        # print("x ", x, " y ", y, " area ", area, "\n")
        # total_travelled += distance
        # distance -= 1

        case direction
        when 'R'
            if next_direction == 'U' && horizontal_side == :RIGHT_SIDE
                horizontal_side = :LEFT_SIDE
                distance -= 1
            elsif next_direction == 'D' && horizontal_side == :LEFT_SIDE
                horizontal_side = :RIGHT_SIDE
                distance += 1
            end

            x += distance 
            area += distance * (y)

        when 'L'
            if next_direction == 'U' && horizontal_side == :RIGHT_SIDE
                horizontal_side = :LEFT_SIDE
                distance += 1
            elsif next_direction == 'D' && horizontal_side == :LEFT_SIDE
                horizontal_side = :RIGHT_SIDE
                distance -= 1
            end

            x -= distance
            area -= distance * (y)
            # total_travelled += 1
        when 'U'
            if next_direction == 'R' && vertical_side == :BOTTOM_SIDE
                vertical_side = :TOP_SIDE
                distance += 1
            elsif next_direction == 'L' && vertical_side == :TOP_SIDE
                vertical_side = :BOTTOM_SIDE
                distance -= 1
            end

            y -= distance

        when 'D'
            if next_direction == 'L' && vertical_side == :TOP_SIDE
                vertical_side = :BOTTOM_SIDE
                distance += 1
            elsif next_direction == 'R' && vertical_side == :BOTTOM_SIDE
                vertical_side = :TOP_SIDE
                distance -= 1
            end

            y += distance
        end
        print("Direction: ", direction, " - Distance: ", distance, ": [x,y]: ", x,", ", y.to_s.rjust(2), " Area: ", area, "\n")
        print("NextDirection: ", next_direction, ", VerticalSide: ", vertical_side, " HorizontalSide: ", horizontal_side, "\n")
        # p(area)
    end

    p("Travel Distance", total_travelled)
    p("Area", area.abs)
    area.abs
end

def area(nodes)

    
    nodes = nodes.sort_by{[_1[1], _1[0]]}
    total = 0
    before_nodes = nodes.dup.map{[_1, "$"]}

    # draw(nodes.map{[_1[0], _1[1]]}, [])
    square_col = 0
    dump_vectors = []
    col_i = 0
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

        color = SQUARE_COLORS[col_i.dup % SQUARE_COLORS.size].dup
        # p(color)
        size_vector = (bottom_right_node - top_left_node)
        size_vector[1].times do |y|
            (size_vector[0] + 1).times do |x|
                dump_vectors << [
                    top_left_node[0] + x,
                    top_left_node[1] + y,
                    # Proc.new{|str| str.colorize(SQUARE_COLORS[col_i.dup % SQUARE_COLORS.size])}
                    color
                ]
            end
        end

        # p(SQUARE_COLORS[col_i.dup % SQUARE_COLORS.size])

        col_i += 1
        # p(dump_vectors.map{[_1[0], _1[1]]})
        # exit

        dump_vectors.uniq
        # p(dump_vectors)
        # s
        # if overdone.size > 0
        #     p(overdone)
        #     exit
        # end
        # if overdone.size > 0
        #     p("Overdone")
        #     p(overdone)
        #     exit
        # end

        # p(dump_vectors)
        # exit
        # p(f)
        # exit
        size = (size_vector[0] + 1) * (size_vector[1])
        total += size

        if nodes.size == 2 && potential_bottom_left_node == bottom_left_node && potential_bottom_right_node == bottom_right_node
            (bottom_right_node[0] - bottom_left_node[0] + 1).times do |x|
                dump_vectors << [bottom_left_node[0] + x, bottom_left_node[1], :blue]
            end
            # dump_vectors.uniq
            # p(dump_vectors)
            # print("\nTotal: ", (bottom_right_node[0] - bottom_left_node[0]) + 1, " Total Vectors ", dump_vectors.size, " Total Unique Vectors: ", dump_vectors.uniq.size, "\n")
            File.open('./day18/part2.json', 'w') { |file| file.write(dump_vectors.map{[_1[0], _1[1]]}.to_json) }

            # draw(dump_vectors.uniq, dump_vectors)
            # p(dump_vectors.uniq.size)
            # p(dump_vectors.size)
            # exit
            print("\n\n")
            draw(dump_vectors, before_nodes)
            print("\n\n=============\n\n")
            # p(dump_vectors.size, dump_vectors.uniq.size)
            return total + (bottom_right_node[0] - bottom_left_node[0]) + 1
        end

        # should be 34329

        # prev_total = total
        bottom_nodes = nodes.filter{_1[1] == bottom_left_node[1]}
        
        offset = 0
        if bottom_left_node == potential_bottom_left_node
            if (index = bottom_nodes.index(bottom_left_node)) % 2 == 0
                (bottom_nodes[index + 1][0] - bottom_left_node[0]).times do |x|
                    dump_vectors << [bottom_left_node[0] + x, bottom_left_node[1], :cyan]
                end
                dump_vectors.uniq
                offset += bottom_nodes[index + 1][0] - bottom_left_node[0]
            end
            nodes.delete(bottom_left_node)

            # p("Run once")
            # Actually important! Work out why!
            # bottom_nodes.delete(bottom_left_node)
        else
            nodes << bottom_left_node
            before_nodes << [bottom_left_node, "~"]
        end

        if bottom_right_node == potential_bottom_right_node
            if (index = bottom_nodes.index(bottom_right_node)) % 2 == 1

                
                # p(bottom_nodes)
                # print("BottomFirst: ", bottom_nodes[index - 1], "; BottomRight: ", bottom_right_node, "\n")

                (bottom_right_node[0] - bottom_nodes[index - 1][0]).times do |x|
                    # print("Writing with an X of ", bottom_nodes[index - 1][0], "\n")
                    dump_vectors << [bottom_nodes[index - 1][0] + x + 1, bottom_right_node[1], :magenta]
                end

                offset += bottom_right_node[0] - bottom_nodes[index - 1][0]
            end
            nodes.delete(bottom_right_node)
        else
            nodes << bottom_right_node
            before_nodes << [bottom_right_node, "~"]
        end

        total += offset
        # print("Square ", top_left_node, " ", top_right_node, " ", bottom_left_node, " ", bottom_right_node, "- Size ", size, "\n")
        # print("Size of Square: ", size, ", Adjustment: ", offset, ", Vector: ", size_vector, ", New Total: ", total, " Total Vectors: ", dump_vectors.size, ", Remaining:", nodes.size, "\n")

        # if nodes.size == 1
        #     p("Breaking")
        #     break
        # end

        # if nodes.size == 0
        #   total += 1
        # end
        nodes.sort_by!{[_1[1], _1[0]]}
    end

    exit("Should never get here")
    #p("Total", total, "Total Vectors", dump_vectors.size)
end