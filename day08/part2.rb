#!/usr/bin/env ruby

input = STDIN.read.lines(chomp: true)
instructions = input.shift.split("").map{_1 == "L" ? 0 : 1}

value = input
    .reject{_1.empty?}
    .each_with_object(Hash.new) do |row, acc|
        map = row.scan(/[\dA-Z]+/)
        acc[map[0]] = [map[1], map[2]]
    end

result = Struct.new(:iterations, :loop_iterations)

positions = value.keys.filter{_1.end_with?("A")}

def calculate(instructions, value, node)
    start_node = node
    # end_node = node[0..1] + "Z"
    # end_node = "ZZZ"
    i = 0
    result = []
    last_found_exit_node = nil
    while(true) do
        # print(node, " - ", , "\n")
        node = value[node][instructions[i % instructions.size]]
        # Then this is the end result

        if node.end_with?("Z")
            last_found_exit_node = node if last_found_exit_node.nil?
            result << i + 1
            if result.size == 2
                if last_found_exit_node != node
                    throw new Error("Different nodes found - " + last_found_exit_node + ", " + node)
                end
                return [result[0], result[1] - result[0]]
            end
        end
        i+=1
    end
    # p("Returning for ", value)
    result
end

result = positions
    .map{calculate(instructions, value, _1)}
    .map{_1[0]}
# result = calculate(instructions, value, positions[0])

# p(calc)

# result = result.reduce(:*)

# while(true) do
#     positions = positions.map do |pos|
#         value[pos][instructions[i  % instructions.size]]
#     end

#     # p(positions)

#     i+=1

#     break if positions.all?{_1.end_with?("Z")}
# end
# p(result)

p(result.reduce(1, :lcm))

