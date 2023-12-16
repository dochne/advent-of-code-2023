#!/usr/bin/env ruby

require "matrix"


Beam = Struct.new(:location, :direction)

GRID = STDIN.read.lines(chomp: true)
    .map{_1.split("")}

def resolve_beam(beam, visited)
    beam.location += beam.direction

    if beam.location[0] < 0 || beam.location[1] < 0 || beam.location[0] >= GRID.size || beam.location[1] >= GRID[0].size
        return visited
    end

    value = GRID[beam.location[1]][beam.location[0]]
    visited[beam.location] = [] if visited[beam.location].nil?
    
    if visited[beam.location].include? beam.direction
        return visited
    end

    visited[beam.location] << beam.direction
    beams = []
    case value
    when "|"
        if beam.direction[0].abs == 1 # If it's travelling horizontally
            beams << beam.dup.tap { _1.direction = Vector[0, -1]}
            beams << beam.dup.tap { _1.direction = Vector[0, 1]}
        else
            beams << beam
        end
    when "-"
        if beam.direction[1].abs == 1 # If it's travelling vertically
            beams << beam.dup.tap { _1.direction = Vector[-1, 0]}
            beams << beam.dup.tap { _1.direction = Vector[1, 0]}
        else
            beams << beam
        end
    when "/"
        beams << beam.dup.tap { _1.direction = (Vector[_1.direction[1], _1.direction[0]] * -1)}
        # 1, 0 will turn into 0, -1
        # -1, 0 will turn into 0, 1
        # 0, -1
    when "\\"
        # 1, 0 will become 0, 1
        beams << beam.dup.tap { _1.direction = (Vector[_1.direction[1], _1.direction[0]])}
    else
        beams << beam
    end

    beams.each do |beam|
        visited = resolve_beam(beam, visited)
    end

    visited
end

coverages = []
GRID.each_with_index do |row, row_idx|
    coverages << resolve_beam(Beam.new(Vector[-1, row_idx], Vector[1, 0]), {})
    coverages << resolve_beam(Beam.new(Vector[row.size, row_idx], Vector[-1, 0]), {})
end

GRID[0].each_with_index do |col, col_idx|
    coverages << resolve_beam(Beam.new(Vector[col_idx, -1], Vector[0, 1]), {})
    coverages << resolve_beam(Beam.new(Vector[col_idx, GRID.size], Vector[0, -1]), {})
end
# visited = 

p(coverages.map(&:size).max)

