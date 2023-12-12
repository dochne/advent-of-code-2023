#!/usr/bin/env ruby

require "matrix"

input = STDIN.read.lines(chomp: true)
    .map{_1.split("")}
    .reduce([]) do |acc, line|
        acc << line if line.index("#").nil?
        acc << line
    end
    .transpose
    .reduce([]) do |acc, line|
        acc << line if line.index("#").nil?
        acc << line
    end
    .transpose
    .each_with_index.reduce([]) do |acc, (line, row_idx)|
        col_idx = -1
        while col_idx = line.join("").index("#", col_idx + 1)
            acc << Vector[row_idx, col_idx]
        end
        acc
    end

p(input)
distances = input.reduce([]) do |acc, vector|
    input.each do |compare_vector|
        horizontal = [vector[0].abs, compare_vector[0].abs]
        vertical = [vector[1].abs, compare_vector[1].abs]
        acc << (horizontal.max - horizontal.min) + (vertical.max - vertical.min)
        # if min_distance.nil? || compare_distance < min_distance
        #     min_distance = compare_distance
        #     # print("Min:", min_distance, " Vec: ", vector, "Compare: ", compare_vector, "\n")
        # end
    end
    acc
end

p(distances.sum / 2)
# distances = input.map do |vector|
#     min_distance = nil
#     input.each do |compare_vector|
#         if vector == compare_vector
#             next
#         end

#         horizontal = [vector[0].abs, compare_vector[0].abs]
#         vertical = [vector[1].abs, compare_vector[1].abs]
#         compare_distance = (horizontal.max - horizontal.min) + (vertical.max - vertical.min)
#         if min_distance.nil? || compare_distance < min_distance
#             min_distance = compare_distance
#             print("Min:", min_distance, " Vec: ", vector, "Compare: ", compare_vector, "\n")
#         end
#     end
#     min_distance
# end

# p(distances)

# input.each do |line|
#     print(line.join(""), "\n")
# end


# ....#........
# .........#...
# #............
# .............
# .............
# ........#....
# .#...........
# ............#
# .............
# .............
# .........#...
# #....#.......

#p(value)
