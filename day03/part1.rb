#!/usr/bin/env ruby

require "colorize"

input = STDIN.read.lines(chomp: true)
    
PartNumber = Struct.new(:line, :char, :number, :valid)

part_numbers = input.each_with_index.each_with_object [] do |(line, index), acc|
    current_number = nil
    line.split("").each_with_index do |char, char_index|
        if char.match(/\d/)
            current_number = PartNumber.new(index, char_index, "", false) if current_number.nil?
            current_number[:number] += char
        elsif current_number != nil
           acc.append current_number
           current_number = nil
        end
    end
    if current_number != nil
        acc.append current_number
    end
end
.map do |part|
    text = ""
    start_char = [0, part.char - 1].max
    end_char = part.char + part.number.size + 1

    start_line = [0, part.line - 1].max
    end_line = part.line + 1

    Range.new(start_line, end_line).each do |line|
        text += (input[line][start_char...end_char]) + "\n" if !(input[line].nil?)
    end
    
    part[:valid] = !text.match(/[^\d.\n]/).nil?
    part
end


output = input
part_numbers.reverse.each do |part|
    output[part.line][part.char, (part.number.size)] = part[:valid] ? part.number.green : part.number.red
end
output.each{print(_1 + "\n")}

numbers = part_numbers
    .filter(&:valid)
    .map(&:number)
    # .map{p(_1)}
    .map{_1.to_i}
    .sum

p(numbers)
