#!/usr/bin/env ruby

require "matrix"

Node = Struct.new(:vector, :value, :child_nodes)

input = STDIN.read.lines(chomp: true)
    .map{_1.split("")}


nodes = {}
input.each_with_index do |row, row_idx|
    row.each_with_index do |value, col_idx|
        next if value == "#"
        nodes[Vector[col_idx, row_idx]] = Node.new(Vector[col_idx, row_idx], value, []) 
    end
end

# start = Vector[input.first.find_index{_1 == "."}, 0]
# last = Vector[input.last.find_index{_1 == "."}, input.size - 1]

# nodes = Hash.new{|h, k| h[k] = Node.new(k, [])}
# grid.each do |position, value| nodes[position] = 
nodes.each do |position, node|
    potential_directions = case node.value
        when "."
            [Vector[1, 0], Vector[-1, 0], Vector[0, 1], Vector[0, -1]]
        when "<"
            [Vector[-1, 0]]
        when ">"
            [Vector[1, 0]]
        when "^"
            [Vector[0, -1]]
        when "v"
            [Vector[0, 1]]
        end

    potential_directions.each do |direction|
        node.child_nodes << nodes[position + direction] if nodes[position + direction]
    end
end

def find_paths(node, stop, visited = [])
    path = []
    
    if node == stop
        return visited.size
    end

    visited = visited.dup
    visited << node

    node.child_nodes.each do |child_node|
        next if visited.include? child_node
        value = find_paths(child_node, stop, visited)
        path << value if !value.nil?
    end

    path.flatten
end


start = nodes.find{|k, v| v.vector[1] == 0}[1]
stop = nodes.find{|k, v| v.vector[1] == input.size - 1}[1]

p(find_paths(start, stop).max)
# p(start.nil?, stop.nil?)
exit
# find_paths()
# p(nodes)
# exit

# We doth not care 
# grid = grid.filter{|key, value| value != "#"}

# input.each_with_index do row, row_idx
#     row.each_with_index do value, col_idx
#         next if value == "#"
#         potential_directions = case value
#         when "."
#             [Vector[1, 0], Vector[-1, 0], Vector[0, 1], Vector[0, -1]]
#         when "<"
#             [Vector[-1, 0]]
#         when ">"
#             [Vector[1, 0]]
#         when "^"
#             [Vector[0, -1]]
#         when "v"
#             [Vector[0, 1]]
#         end
        
#         potential_directions.each do |direction|
#             if 
#         next_potential_directions =
            
#     end
# end
# p(start, last)

# p(input)
