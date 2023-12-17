#!/usr/bin/env ruby

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

def walk(start, goal, heuristic)
    open_set = Set.new([start])
    came_from = {}

    g_score = Hash.new{|h,k| Float::INFINITY}
    g_score[start] = 0
    f_score = Hash.new{|h,k| Float::INFINITY}
    f_score[start] = 0


    while !open_set.empty?
        # p(open_set)
        current = f_score.filter{open_set.include? _1}.min_by.first[0]
        if current == goal
            return reconstruct_path(came_from, current)
        end

        
        open_set.delete(current)
        
        # exit
        
        [Vector[-1, 0], Vector[1, 0], Vector[0, -1], Vector[0, 1]].each do |dir|
            neighbour = current + dir
            next if neighbour[1] < 0 || neighbour[0] < 0 || GRID[neighbour[1]].nil? || GRID[neighbour[1]][neighbour[0]].nil?

            prev = came_from[current]
            if !prev.nil?
                prev_prev = came_from[prev]
                if !prev_prev.nil?
                    prev_prev_prev = came_from[prev_prev]
                    if !prev_prev_prev.nil?
                        next if prev_prev_prev == current + ((dir * -1) * 3)
                    end
                end
            end

            VISITED[neighbour] += 1

            # p(neighbour)
            # p(GRID[neighbour[1]][neighbour[0]])
            # exit
            # We need to handle "our extra "no three in a row here" too

            # p(GRID[neighbour[1]][neighbour[0]])

            tentative_gscore = g_score[current] + GRID[neighbour[1]][neighbour[0]]

            if g_score[neighbour].nil? || tentative_gscore < g_score[neighbour]
                came_from[neighbour] = current
                g_score[neighbour] = tentative_gscore
                f_score[neighbour] = tentative_gscore + heuristic.call(neighbour, goal)
                open_set.add(neighbour)
            end
        end
    end

    return nil
end

GRID = STDIN.read.lines(chomp: true)
    .map{_1.split("").map(&:to_i)}
VISITED = Hash.new{|h, k| h[k] = 0}

value = walk(Vector[0, 0], Vector[12, 12], Proc.new do 
    |from, to| print("From ", from, "To ", to, "\n")
    diff = to - from
    diff[0] + diff[1]
end)

p("Value", value)

GRID.each_with_index do |row, row_idx|
    row.each_with_index do |col, col_idx|
        if value.include?(Vector[col_idx, row_idx])
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
value[1..].each do |vec|
    score += GRID[vec[1]][vec[0]]
end
p(score)
