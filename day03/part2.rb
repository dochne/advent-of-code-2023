#!/usr/bin/env ruby

require "colorize"

input = STDIN.read.lines(chomp: true)
    
PartNumber = Struct.new(:line, :char, :number, :valid)
Gear = Struct.new(:line, :char, :valid)

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
    
    part[:valid] = !text.match(/\*/).nil?
    part
end
.filter(&:valid)

gears = input.each_with_index.each_with_object [] do |(line, line_index), gears|
    line.split("").each_with_index do |char, char_index|
        gears.append Gear.new(line_index, char_index, false) if char == "*"
    end
end

value = 0
gears.each do |gear|
    adj = []
    part_numbers.each do |part|
        if gear.line - 1 <= part.line && part.line <= gear.line + 1 &&
            gear.char <= part.char + part.number.size && part.char <= gear.char + 1
            adj += [part]
        end
    end

    if (adj.size == 2) 
        gear[:valid] = adj.size == 2
        value += adj.map(&:number).map(&:to_i).reduce(:*)
    elsif (adj.size > 2) 
        gear[:valid] = adj.size
    end
end

output = input
gears.reverse.each do |gear|
    output[gear.line][gear.char] = case gear[:valid]
    when true
        "*".green
    when false
        "*".red
    else
        gear[:valid].to_s.blue
    end if !output[gear.line].nil?
end

output.each{print(_1 + "\n")}

p(value)
