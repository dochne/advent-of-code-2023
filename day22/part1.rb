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
            # .yield_self do |value|
            #     p(value[0][2])
            #     exit
            # end
            # .sort_by{
            #     p(_1)
            #     exit
            # } # sort by z
# 461
        # name = index
        name = index + 65 < 91 ? (index+65).chr : index
        # Brick.new(name, from, to)
            #(index + 65).chr
        Brick.new(index, from, to)
    end
    .sort_by{ _1.to[2] }
    # .slice(0, 50)

# p(bricks.map(&:from))
# exit
    
# 461 is too low    
# 565 is too high
grid = {} # Hash.new{|k,v| 0}
bricks.each do |brick|

    # p(brick)
    # exit
    # print("Keys0 ", grid.keys, "\n")
    offsets = brick.cell_offsets
    squares_by_height = grid.filter{|k, v| offsets.include?(k)}.sort_by{|k, s| -s.height}.to_h
    # If there's nothing in the noted cells (a cell being x,y) we fall to the floor
    # if squares_by_height.empty?
    #     print("This was triggered for ", brick.name, "\n")
    # end
    # print("Keys1 ", grid.keys, "\n")
    if squares_by_height.empty?
        grid.merge!(offsets.map{[_1, Square.new(brick.height, brick)]}.to_h) 
        print("Putting brick #{brick.name} #{brick.from} -> #{brick.to} on row ", brick.height, "\n")
        next 
    end
    # print("Keys2 ", grid.keys, "\n")
    top_square_height = squares_by_height.first[1].height
    highest_squares = squares_by_height.filter{|k, s| s.height == top_square_height}.to_h

    # If we only have one supporting brick below us, then we tell that brick that it's important
    supporting_bricks = highest_squares.values.uniq
    if supporting_bricks.size == 1
        # p(supporting_bricks.first.top_brick.supporting)
        # exit
        supporting_bricks.first.top_brick.supporting << brick
    end

    print("Putting brick #{brick.name} on row ", top_square_height + brick.height, "\n")

    offsets.each do |cell|
        # p("Floor", floor[cell], "Higest", highest_cell, "BrickHgith", brick.height)
        grid[cell] = Square.new(top_square_height + brick.height, brick)
        # floor[cell][1]
    end

    # all_supporting = []
    # highest_cells.each do |cell, (height, cell_brick)|
    #     break if height != highest_cell
    #     all_supporting << cell_brick
    # end

    # if all_supporting.size == 1
    #     all_supporting.each do |cell_brick|
    #         cell_brick.supporting << brick # 1 # We're supporting a brick!
    #     end
    # end

    # offsets.each do |cell|
    #     # p("Floor", floor[cell], "Higest", highest_cell, "BrickHgith", brick.height)
    #     floor[cell] = [highest_cell + brick.height, brick]
    #     # floor[cell][1]
    # end
end

bricks.each do |brick|
    next if brick.supporting.size == 0
    print("Brick ", brick.name, " supporting ", brick.supporting.map{_1.name}.join(", "), "\n")
end

# bricks[0..10].each do |brick|
#     p(brick)
# end
p(bricks.filter{_1.supporting.size == 0}.size)
# p(grid)
# bricks = bricks.filter{_1.supporting > 0}.size
# p(bricks)
exit

# Brick.new(from, to)
# So, what we're really asking is "will this intersect"

cells = []
highest_brick_cell = 0
stack = []
bricks.each do |brick|
    brick.offset(highest_brick_cell)
end
# p(bricks[0])
# bricks[0].from.each2(bricks[0].to) do 
#     p(_1)
# end

exit

stack = [
    # There can be n blocks on a given layer
    [bricks.shift]
]

p(stack)
exit

# # p(input)
# # exit
# while brick = bricks.shift do
#     stack_pos = stack.size - 1
#     stack[stack_pos].each do |existing_brick|
        

# end


    

# p(input)
