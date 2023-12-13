#!/usr/bin/env ruby

input = STDIN.read.lines(chomp: true)
    .join("\n")
    .split("\n\n")
    .map{_1.split("\n")}
    .map do |grid|
        transposed = grid
            .map{_1.split("")}
            .transpose
            .map{_1.join("")}

        response = nil

        grid.each_with_index do |row, pivot|
            next if pivot == 0

            value = pivot.times.all? do |row_idx|
                grid[pivot - (row_idx + 1)] == grid[pivot + row_idx] || grid[pivot + row_idx].nil?
            end

            if value
                response = (pivot) * 100
                break
            end
        end

        transposed.each_with_index do |col, pivot|
            next if pivot == 0

            value = pivot.times.all? do |col_idx|
                transposed[pivot - (col_idx + 1)] == transposed[pivot + col_idx] || transposed[pivot + col_idx].nil?
            end

            if value
                response = (pivot)
                break
            end
        end
        response
    end

p(input.sum)
