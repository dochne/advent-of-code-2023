#!/usr/bin/env ruby

input = STDIN.read.lines(chomp: true)
    .map{_1.scan(/^([%&])?([^ ]*) -> (.*)/).first}
    .map{[_1, _2, _3.split(", ")]}

inputs = input.reduce(Hash.new{|h, k| h[k] = []}) do |acc, (type, name, dests)|
    dests.each {|dest| acc[dest] << name }
    acc
end

modules = input.reduce({}) do |acc, (type, name, dests)|
    acc[name] = {
        type: type,
        state: 0,
        dests: dests
    }
    acc
end

modules = modules.map do |key, value|
    value[:inputs] = inputs[key].map{modules[_1]}
    [key, value]
end.to_h

modules["button"] = {type: "output",state: nil,dests: []}

# I'm not convinced this would work with all cases, but I made sense of the graph with mermaid first to take this approach
combiner = inputs["rx"][0]
combination = inputs[combiner]
combination_map = {}

combination.each do |comb|
    print("Trying to solve ", comb, "\n")
    button_press = 0

    modules.each do |k, mod|
        mod[:state] = 0
    end

    loop do
        break if !combination_map[comb].nil?
        button_press += 1
        print("ButtonPress ", button_press, "\n") if button_press % 100000 == 0

        stack = [["broadcaster", "button"]]
        while (name, from = stack.shift) do
            pulse = modules[from][:state]
            mod = modules[name]

            if name == comb && pulse == 0
                break combination_map[comb] = button_press
            end

            next if mod.nil?

            if mod[:type] == "%"
                if pulse == 0
                    mod[:state] = (mod[:state] + 1) % 2
                    mod[:dests].each { |dest| stack << [dest, name]}
                end
            elsif mod[:type] == "&"
                mod[:state] = mod[:inputs].all?{_1[:state] == 1} ? 0 : 1

                mod[:dests].each { |dest| stack << [dest, name ]}
            elsif mod[:type] == nil
                # Broadcaster!
                mod[:dests].each { |dest| stack << [dest, name ]}
            end
        end
    end
end

p(combination_map.values.reduce(1, :lcm))

