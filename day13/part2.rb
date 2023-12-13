#!/usr/bin/env ruby

require "levenshtein"

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

            text = ""
            compare_text = ""
            value = pivot.times.each do |row_idx|
                break if grid[pivot + row_idx].nil?
                text += grid[pivot - (row_idx + 1)]
                compare_text += grid[pivot + row_idx]
            end

            if Levenshtein.distance(text, compare_text) == 1
                response = (pivot) * 100
                break
            end
        end

        transposed.each_with_index do |col, pivot|
            next if pivot == 0

            text = ""
            compare_text = ""
            value = pivot.times.each do |col_idx|
                break if transposed[pivot + col_idx].nil?
                text += transposed[pivot - (col_idx + 1)]
                compare_text += transposed[pivot + col_idx]
            end

            if Levenshtein.distance(text, compare_text) == 1
                response = (pivot)
                break
            end
        end
        response
    end

p(input.sum)
