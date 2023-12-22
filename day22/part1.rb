#!/usr/bin/env ruby

require "matrix"
require_relative "shared"


class Brick
    attr_accessor :from, :to
    
    def initialize(from, to)
        @from = from
        @to = to
    end

    def cells(offset)
        offset_vector = Vector[0, -offset , 0]
        [@from - offset_vector].inner_cells(@to - offset_vector)
    end
end
# Brick = Struct.new(:from, :to, :supporting)

bricks = STDIN.read.lines(chomp: true)
    .map do |row|
        from, to = row.split("~")
            .map{_1.split(",").map(&:to_i)}
            .map{Vector[_1[0], _1[1], _1[2]]}
            .sort_by{[_1[0][2]]} # sort by z
        Brick.new(from, to)
    end

floor = []

p(bricks)
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
