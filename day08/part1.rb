#!/usr/bin/env ruby

input = STDIN.read.lines(chomp: true)
instructions = input.shift.split("").map{_1 == "L" ? 0 : 1}

value = input
    .reject{_1.empty?}
    .each_with_object(Hash.new) do |row, acc|
        map = row.scan(/[A-Z]+/)
        acc[map[0]] = [map[1], map[2]]
    end

i = 0
pos = "AAA"
while(true) do
    pos = value[pos][instructions[i  % instructions.size]]
    i+=1
    break if pos == "ZZZ"
end
p(i)