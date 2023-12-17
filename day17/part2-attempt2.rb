#!/usr/bin/env ruby --yjit

require "matrix"
require "colorize"
require "rb_heap"

Node = Struct.new(:position, :direction, :score, :route)

def walk(grid, start, goal)
    heap = Heap.new { |a, b| a.score < b.score }
    heap << Node.new(start, Vector[0, 0], 0, [])
    scores = {}

    while (node = heap.pop) do
        return node.score, node.route if node.position == goal

        [Vector[-1, 0], Vector[1, 0], Vector[0, -1], Vector[0, 1]].each do |dir|
            next if dir == node.direction || dir == node.direction * -1

            new_score = node.score
            1.upto(10) do |distance|
                next_pos = node.position + (dir * distance)

                break if next_pos[0] < 0 || next_pos[1] < 0 || grid.size <= next_pos[1] || grid[0].size <= next_pos[0]

                new_score += grid[next_pos[1]][next_pos[0]]
                next if distance <= 3

                next_node = Node.new(next_pos, dir, new_score, node.route + [next_pos])
                next if scores.fetch([next_pos, dir], Float::INFINITY) <= new_score

                scores[[next_pos, dir]] = new_score
                heap << next_node
            end
        end
    end

    return nil
end

input = STDIN.read.lines(chomp: true)
    .map{_1.split("").map(&:to_i)}

score, route = walk(input, Vector[0, 0], Vector[input[0].size - 1, input.size - 1])

input.each_with_index do |row, row_idx|
    row.each_with_index do |col, col_idx|
        print(route.include?(Vector[col_idx, row_idx]) ? col.to_s.red : col.to_s)
    end
    print("\n")
end

p(score)
