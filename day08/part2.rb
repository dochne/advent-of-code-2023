#!/usr/bin/env ruby

input = STDIN.read.lines(chomp: true)
instructions = input.shift.split("").map{_1 == "L" ? 0 : 1}

node_tree = input
    .reject{_1.empty?}
    .each_with_object(Hash.new) do |row, acc|
        map = row.scan(/[\dA-Z]+/)
        acc[map[0]] = [map[1], map[2]]
    end

result = node_tree
    .keys
    .filter{_1.end_with?("A")}
    .map do |node|
        i = 0
        until node.end_with?("Z")
            node = node_tree[node][instructions[i % instructions.size]]
            i+=1
        end
        i
    end
    .reduce(1, :lcm)

p(result)
