#!/usr/bin/env ruby

require "matrix"

Node = Struct.new(:id, :vector, :value, :child_nodes)

input = STDIN.read.lines(chomp: true)
    .map{_1.split("")}


nodes = {}    
id = 0
input.each_with_index do |row, row_idx|
    row.each_with_index do |value, col_idx|
        next if value == "#"
        nodes[Vector[col_idx, row_idx]] = Node.new(id, Vector[col_idx, row_idx], value, []) 
        id += 1
    end
end

nodes.each do |position, node|
    [Vector[1, 0], Vector[-1, 0], Vector[0, 1], Vector[0, -1]].each do |direction|
        node.child_nodes << nodes[position + direction] if nodes[position + direction]
    end
end

def find_paths(node, stop, visited = [])
    path = []
    
    if node.id == stop.id
        return visited.size
    end

    visited = visited.dup
    visited << node.id

    node.child_nodes.each do |child_node|
        next if visited.include? child_node.id
        value = find_paths(child_node, stop, visited)
        path << value if !value.nil?
    end

    path.flatten
end


start = nodes.find{|k, v| v.vector[1] == 0}[1]
stop = nodes.find{|k, v| v.vector[1] == input.size - 1}[1]

p(find_paths(start, stop).max)
exit