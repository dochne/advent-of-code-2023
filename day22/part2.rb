#!/usr/bin/env ruby

require "matrix"
require_relative "shared"

class Brick
    attr_accessor :name, :from, :to, :parent_bricks, :child_bricks
    
    def initialize(name, from, to)
        @name = name
        @from = from
        @to = to
        @parent_bricks = []
        @child_bricks = []
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

Square = Struct.new(:height, :top_brick)

bricks = STDIN.read.lines(chomp: true)
    .each_with_index
    .map do |row, index|
        from, to = row.split("~")
            .map{_1.split(",").map(&:to_i)}
            .map{Vector[_1[0], _1[1], _1[2]]}
            
        name = index + 65 < 91 ? (index+65).chr : index
        Brick.new(name, from, to)
    end
    .sort_by{ _1.to[2] }

grid = {} # Hash.new{|k,v| 0}
bricks.each do |brick|
    offsets = brick.cell_offsets
    squares_by_height = grid.filter{|k, v| offsets.include?(k)}.sort_by{|k, s| -s.height}.to_h

    if squares_by_height.empty?
        grid.merge!(offsets.map{[_1, Square.new(brick.height, brick)]}.to_h) 
        # print("Putting brick #{brick.name} #{brick.from} -> #{brick.to} on row ", brick.height, "\n")
        next 
    end

    top_square_height = squares_by_height.first[1].height
    highest_squares = squares_by_height.filter{|k, s| s.height == top_square_height}.to_h

    # If we only have one supporting brick below us, then we tell that brick that it's important
    parent_bricks = highest_squares.values.uniq

    # We store the information about the supported bricks
    brick.parent_bricks = parent_bricks.map{_1.top_brick}
    
    # And we tell the brick that it's supporting us
    parent_bricks.each do |parent_brick|
        parent_brick.top_brick.child_bricks << brick
        parent_brick.top_brick.child_bricks.uniq!
    end

    offsets.each do |cell|
        grid[cell] = Square.new(top_square_height + brick.height, brick)
    end
end

def calc_falling(brick, fallen)
    print(" Calculating for #{brick.name}\n")

    # For every brick we're supporting - we want to know 
    total = brick.supporting.size
    brick.supporting.each do |new_brick|
        total += calc_falling(new_brick)
    end
    print(" #{brick.name} #{total} bricks falling\n")
    total
end

total_falling = 0
bricks.each do |brick|
    
    next if brick.child_bricks.size == 0

    # print("Disintegrating #{brick.name}\n")

    brick_falling = 0
    fallen = [brick]
    queue = [brick]

    while (next_brick = queue.shift) do
        # print("  Investigating ", next_brick.name, "\n")
        # print("    ChildBricks: ", next_brick.child_bricks.map{_1.name}.join(", "), "\n")
        # print("    ParentBricks: ", next_brick.parent_bricks.map{_1.name}.join(", "), "\n")

        if next_brick == brick || next_brick.parent_bricks.all?{|nb| fallen.include?(nb) }
            # print("    - Collapsing\n")
            fallen << next_brick
            next_brick.child_bricks.each {|child_brick| queue << child_brick}
            brick_falling += 1 if next_brick != brick
        end

        queue.uniq!
    end

    # print("Bricks falling for #{brick.name} - #{brick_falling}\n")

    total_falling += brick_falling
end

p(total_falling)
# p(bricks.filter{_1.supporting.size == 0}.size)
