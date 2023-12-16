#!/usr/bin/env ruby

require "matrix"


Beam = Struct.new(:location, :direction)

grid = STDIN.read.lines(chomp: true)
    .map{_1.split("")}


# visited = Hash.new{|h, k| h[k]=[]}
visited = {}

def resolve_beam(beam, grid, visited)
    beam.location += beam.direction

    if beam.location[0] < 0 || beam.location[1] < 0 || beam.location[0] >= grid.size || beam.location[1] >= grid[0].size
        return
    end

    value = grid[beam.location[1]][beam.location[0]]

    # p(beam.location, value)

    visited[beam.location] = [] if visited[beam.location].nil?
    p("Beam", beam)
    if visited[beam.location].include? beam.direction
        return
    end
    visited[beam.location] << beam.direction
    beams = []
    case value
    when nil
        return # this beam is done
    when "|"
        p(beam)
        if beam.direction[0].abs == 1 # If it's travelling horizontally
            p("travelling horizontally")
            beams << beam.dup.tap { _1.direction = Vector[0, -1]}
            beams << beam.dup.tap { _1.direction = Vector[0, 1]}
            p(beams)
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
        resolve_beam(beam, grid, visited)
    end

end



resolve_beam(Beam.new(Vector[-1, 0], Vector[1, 0]), grid, visited)

grid.each_with_index do |row, row_idx|
    row.each_with_index do |col, col_idx|
        spaces = visited[Vector[col_idx, row_idx]]
        if col == "." && !spaces.nil? && spaces.size > 0
            if spaces.size  == 1
                val = case spaces[0]
                when Vector[-1, 0]
                    "<"
                when Vector[1, 0]
                    ">"
                when Vector[0, 1]
                    "v"
                when Vector[0, -1]
                    "^"
                else
                    "?"
                end
                # p("Here", val, "foo", spaces[0], spaces[0] == Vector[1, 0])
                print(val)
            else
                print(spaces.size)
            end
            #     if spaces[0] == Vector[-1, 0]
            #         print("^")
            #     elsif spaces[0]
            # print(spaces.size)
        else
            # p("Here")
            print(col)
        end
        # print("\n")
        # exit
    end
    print("\n")
end

p(visited.size)


# p(input)
