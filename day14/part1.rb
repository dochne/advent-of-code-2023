#!/usr/bin/env ruby

input = STDIN.read.lines(chomp: true)
    .map{_1.split("")}
    .transpose
    .map{_1.join("")}
    .map do |column|
        column
            .split("#", -1)
            .map do
                _1.gsub(".", "").ljust(_1.size, ".")
            end
            .join("#")
    end
    .map{_1.split("")}
    .transpose
    
height = input.size
value = input.each_with_index.reduce(0) do |acc, (row, index)|
    acc += row.filter{_1 == "O"}.size * (height - index)
end

p(value)
# input.each do |val|
#     p(val)
# end
# p(input)