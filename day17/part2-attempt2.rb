#!/usr/bin/env ruby --yjit

require "matrix"
require "colorize"
require "rb_heap"

def walk(grid, start, goal)
    heap = Heap.new { |a, b| a[2] < b[2] }
    heap << [start, Vector[0, 0], 0, []]
    seen = Set.new
    scores = {}

    while (pos, last_dir, score, route = heap.pop) do
        return score, route if pos == goal

        [Vector[-1, 0], Vector[1, 0], Vector[0, -1], Vector[0, 1]].each do |dir|
            next if dir == last_dir || dir == last_dir * -1

            new_score = score
            1.upto(10) do |distance|
                next_pos = pos + (dir * distance)

                break if next_pos[0] < 0 || next_pos[1] < 0 || grid.size <= next_pos[1] || grid[0].size <= next_pos[0]

                new_score += grid[next_pos[1]][next_pos[0]]

                next if distance <= 3

                entry = [next_pos, dir, new_score, route + [next_pos]]
                next if seen.include? entry
                next if scores.fetch([next_pos, dir], Float::INFINITY) <= new_score

                scores[[next_pos, dir]] = new_score
                seen.add(entry)
                heap << entry
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
        if route.include?(Vector[col_idx, row_idx])
            print(col.to_s.red)
        else
            print(col.to_s)
        end
    end
    print("\n")
end

p(score)
# p(value)