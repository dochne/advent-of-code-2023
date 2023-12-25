#!/usr/bin/env ruby

edges_input = STDIN.read.lines(chomp: true)
    .map{_1.split(":").map(&:strip)}
    .map{|k, v| [k, v.split(" ")]}
    .reduce([]) {|acc, (src, dsts)| acc + dsts.map{[src, _1]} }
vertices_input = edges_input.flatten.uniq.each_with_object({}) {|value, acc| acc[value] = 1}

loop do
    edges = edges_input.dup
    vertices = vertices_input.dup

    while vertices.size > 2
        u, v = edges.sample
        vertices[u] += vertices[v]
        vertices.delete(v)
        edges.map! { |e| e.map { |x| x == v ? u : x } }
        edges.keep_if { |e| e[0] != e[1] }
    end

    p(edges.size)
    
    if edges.size == 3
        p(vertices.values.reduce(&:*))
        exit
    end
end
