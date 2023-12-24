#!/usr/bin/env ruby
require "matrix"

hail = STDIN.read.lines(chomp: true)
    .map do |row|
        row.split("@").map{_1.strip.split(", ").map{|v| v.strip.to_i}}.map{Vector[_1[0], _1[1], _1[2]]}
    end
    .sort_by{_1[0].to_a}

# Credit to this solution goes to Mads, I never would have clocked this otherwise
# https://github.com/omegahm/advent-of-code/blob/main/2023/24.rb
python = %Q(
from z3 import *
px, py, pz = Real('px'), Real('py'), Real('pz')
vx, vy, vz = Real('vx'), Real('vy'), Real('vz')

s = Solver()
)

python += hail.size.times.map{ |i| "t#{i} = Real('t#{i}')"}.join("\n") + "\n"
python += "\n"
hail.each_with_index do |(pos, vector), idx|
    tname = "t#{idx}"
    # Starting Position + Time * Rock Velocity == Hail Position + Time * Snowflake Velocity
    python += "s.add(px + (#{tname} * vx) == #{pos[0]} + (#{tname} * #{vector[0]}))\n"
    python += "s.add(py + (#{tname} * vy) == #{pos[1]} + (#{tname} * #{vector[1]}))\n"
    python += "s.add(pz + (#{tname} * vz) == #{pos[2]} + (#{tname} * #{vector[2]}))\n"
end

python += "\n"

python += %Q(
if s.check() == z3.sat:
    model = s.model()
    solution_x = model[px]
    solution_y = model[py]
    solution_z = model[pz]
    
    value = model[px] + model[py] + model[pz] 
    print(value)
else:
    print('No solution')
)

# artifact_folder = File.dirname(__FILE__ ) + "/.artifacts"
# p(artifact_folder)
# Dir.mkdir(artifact_folder) if !Dir.exist?(artifact_folder)
# filename = artifact_folder + "/part2.py"
# File.write(filename, python)
# system("python3 #{filename}")

system("echo \"#{python}\" | python3")
