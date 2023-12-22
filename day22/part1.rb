#!/usr/bin/env ruby

require "matrix"
require_relative "shared"


class Brick
    attr_accessor :name, :from, :to, :supporting
    
    def initialize(name, from, to)
        @name = name
        @from = from
        @to = to
        @supporting = []
    end

    def cells(offset)
        offset_vector = Vector[0, -offset , 0]
        [@from - offset_vector].inner_cells(@to - offset_vector)
    end

    def height
        (to[2] - from[2]) + 1
    end

    def cell_offsets
        offsets = []
        (from[0]..to[0]).each do |x|
            (from[1]..to[1]).each do |y|
                offsets << Vector[x, y]
            end
        end
        offsets
    end
end
# Brick = Struct.new(:from, :to, :supporting)

# foo = Brick.new("hi", Vector[0,0,0], Vector[0,0,0])
# p(foo.cell_offsets)
# p(foo.height)


Square = Struct.new(:height, :top_brick)

bricks = STDIN.read.lines(chomp: true)
    .each_with_index
    .map do |row, index|
        from, to = row.split("~")
            .map{_1.split(",").map(&:to_i)}
            .map{Vector[_1[0], _1[1], _1[2]]}
            
        name = index + 65 < 91 ? (index+65).chr : index
        Brick.new(index, from, to)
    end
    .sort_by{ _1.to[2] }

grid = {} # Hash.new{|k,v| 0}
bricks.each do |brick|
    offsets = brick.cell_offsets
    squares_by_height = grid.filter{|k, v| offsets.include?(k)}.sort_by{|k, s| -s.height}.to_h

    if squares_by_height.empty?
        grid.merge!(offsets.map{[_1, Square.new(brick.height, brick)]}.to_h) 
        print("Putting brick #{brick.name} #{brick.from} -> #{brick.to} on row ", brick.height, "\n")
        next 
    end

    top_square_height = squares_by_height.first[1].height
    highest_squares = squares_by_height.filter{|k, s| s.height == top_square_height}.to_h

    # If we only have one supporting brick below us, then we tell that brick that it's important
    supporting_bricks = highest_squares.values.uniq
    if supporting_bricks.size == 1
        supporting_bricks.first.top_brick.supporting << brick
    end

    print("Putting brick #{brick.name} on row ", top_square_height + brick.height, "\n")
    offsets.each do |cell|
        grid[cell] = Square.new(top_square_height + brick.height, brick)
    end
end

bricks.each do |brick|
    next if brick.supporting.size == 0
    print("Brick ", brick.name, " supporting ", brick.supporting.map{_1.name}.join(", "), "\n")
end

p(bricks.filter{_1.supporting.size == 0}.size)
