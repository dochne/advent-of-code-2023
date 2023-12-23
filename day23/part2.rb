#!/usr/bin/env ruby

require "matrix"

Node = Struct.new(:id, :vector, :value, :child_nodes, :length)

input = STDIN.read.lines(chomp: true)
    .map{_1.split("")}


nodes = {}    
id = 0
input.each_with_index do |row, row_idx|
    row.each_with_index do |value, col_idx|
        next if value == "#"
        nodes[Vector[col_idx, row_idx]] = Node.new(id, Vector[col_idx, row_idx], value, [], 0) 
        id += 1
    end
end

nodes.each do |position, node|
    [Vector[1, 0], Vector[-1, 0], Vector[0, 1], Vector[0, -1]].each do |direction|
        node.child_nodes << nodes[position + direction] if nodes[position + direction]
    end
end

nodes.each do |position, node|

    if node.child_nodes.size == 2
        # Find the entries for this node in the nodes next to it
        first_node, second_node = node.child_nodes

        if first_node.child_nodes.size == 2
            first_node.length += node.length + 1
        elsif second_node.child_nodes.size == 2
            second_node.length += node.length + 1
        else
            next
        end

        first_node.child_nodes.delete(node)
        second_node.child_nodes.delete(node)

        first_node.child_nodes << second_node
        second_node.child_nodes << first_node

        nodes.delete(position)
    end
end

def find_paths(node, stop, visited = {})
    return [visited.size] if node.id == stop.id
    path = []

    visited[node.id] = 1

    node.child_nodes.each do |child_node|
        next if visited[child_node.id]
        value = find_paths(child_node, stop, visited)
        path << value.map{_1 + child_node.length} if !value.empty?
    end

    visited.delete(node.id)

    path.flatten
end

start = nodes.find{|k, v| v.vector[1] == 0}[1]
stop = nodes.find{|k, v| v.vector[1] == input.size - 1}[1]

p(find_paths(start, stop).max)
exit