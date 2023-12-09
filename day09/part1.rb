#!/usr/bin/env ruby

input = STDIN.read.lines(chomp: true)
    .map(&:split)
    .map{_1.map(&:to_i)}
    .map do |seq|
        stack = [seq]
        until stack.last.all?{_1 == 0} do
            stack << stack.last.each_cons(2).map{_2 - _1}
        end
        stack.reverse.map(&:last).reduce(0) {|acc, line| line + acc }
    end
    .sum

p(input)