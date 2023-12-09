#!/usr/bin/env ruby

class Array
    def rolling(n)
        res = []
        (self.size - (n - 1)).times do |i|
            res << self[i...i + n]
        end
        res
    end
end

def calc_diff(seq)
    stack = [seq]
    until stack.last.all?{_1 == 0} do
        stack << stack.last.rolling(2).map{_2 - _1}
    end
    stack.reverse.map(&:last).reduce(0) {|acc, line| line + acc }
end

input = STDIN.read.lines(chomp: true)
    .map(&:split)
    .map{_1.map(&:to_i)}
    .map{calc_diff(_1)}
    .sum

p(input)