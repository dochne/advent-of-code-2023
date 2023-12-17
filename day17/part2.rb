#!/usr/bin/env ruby --yjit

require "matrix"
require "colorize"

def reconstruct_path(came_from, current)
    total_path = [current]

    while came_from.has_key? current
        current = came_from[current]
        total_path.prepend current
    end

    return total_path
end

Neighbour = Struct.new(:pos, :dir, :times)

def walk(start, goal, heuristic)
    open_set = Set.new([start])
    came_from = {}

    g_score = Hash.new{|h,k| Float::INFINITY}
    g_score[start] = 0
    f_score = {}
    f_score[start] = 0

    loops = 0
    while !open_set.empty?
        loops+=1
        print(Time.now, " - ", loops, "\n") if loops % 10000 == 0

        current, _ = open_set.reduce(nil) do |acc, set|
            !f_score[set].nil? && (acc.nil? || f_score[set] < acc[1]) ? [set, f_score[set]] : acc
        end

        if current.pos == goal && current.times > 3
            return reconstruct_path(came_from, current)
        end
        
        open_set.delete(current)

        DIRECTIONS.each do |dir|
            next if dir == current.dir * -1
            next if current.times < 4 && dir != current.dir && current.dir != Vector[0,0]
            pos = current.pos + dir
            next if pos[1] < 0 || pos[0] < 0 || GRID[pos[1]].nil? || GRID[pos[1]][pos[0]].nil?
            neighbour = Neighbour.new(pos, dir, dir == current.dir ? current.times + 1 : 1)
            next if neighbour.times > 10

            tentative_gscore = g_score[current] + GRID[pos[1]][pos[0]]

            if tentative_gscore < g_score[neighbour]
                came_from[neighbour] = current
                g_score[neighbour] = tentative_gscore
                f_score[neighbour] = tentative_gscore + (goal - pos).sum
                open_set.add(neighbour)
            end
        end
    end

    return nil
end

GRID = STDIN.read.lines(chomp: true)
    .map{_1.split("").map(&:to_i)}
VISITED = Hash.new{|h, k| h[k] = 0}
DIRECTIONS = [Vector[-1, 0], Vector[1, 0], Vector[0, -1], Vector[0, 1]]

value = walk(
    Neighbour.new(Vector[0, 0], Vector[0, 0], 0),
    Vector[GRID[0].size - 1, GRID.size - 1],
    Proc.new {|from, to| (to - from).sum}
)

if value.nil?
    p("Failed")
    exit
end

value.each do |val|
    p(val)
end


GRID.each_with_index do |row, row_idx|
    row.each_with_index do |col, col_idx|
        if !value.nil? && value.map{_1.pos}.include?(Vector[col_idx, row_idx])
            print(col.to_s.red)
        elsif VISITED[Vector[col_idx, row_idx]]
            print(col.to_s.green)
        else
            print(col.to_s)
        end
    end
    print("\n")
end

score = 0
if !value.nil?
    value[1..].each do |vec|
        score += GRID[vec.pos[1]][vec.pos[0]]
    end
end
p(score)
