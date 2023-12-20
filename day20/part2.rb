#!/usr/bin/env ruby

input = STDIN.read.lines(chomp: true)
    .map{_1.scan(/^([%&])?([^ ]*) -> (.*)/).first}
    .map{[_1, _2, _3.split(", ")]}

inputs = input.reduce(Hash.new{|h, k| h[k] = []}) do |acc, (type, name, dests)|

    dests.each {|dest| acc[dest] << name }
    acc
end

modules = input.reduce({}) do |acc, (type, name, dests)|
    state = case type
    when "%"
        0
    when "&"
        Hash[inputs[name].map{|k| [k, 0]}]
    else
        nil
    end

    acc[name] = {
        type: type,
        state: state,
        dests: dests
    }
    acc
end

modules["output"] = {
    type: "output",
    state: nil,
    dests: []
}

# I'm not convinced this would work with all cases, but I made sense of the graph with mermaid first to take this approach
combiner = inputs["rx"][0]
combination = inputs[combiner]
combination_map = {}

combination.each do |comb|
    p("Trying to solve ", comb)
    button_press = 0

    p("Reset")
    modules.each do |k, mod|
        # p(mod)
        if mod[:type] == "%"
            mod[:state] = 0
        elsif mod[:type] == "&"
            mod[:state].each do |k, v|
                mod[:state][k] = 0
            end
        end
    end

    loop do
        break if !combination_map[comb].nil?
        button_press += 1
        print("ButtonPress ", button_press, "\n") if button_press % 100000 == 0

        stack = [["broadcaster", 0, "button"]]
        while (name, pulse, from = stack.shift) do
            mod = modules[name]
            if name == comb && pulse == 0
                combination_map[comb] = button_press
                break
            end

            # 4001, 3847, 3877, 3823
            
            next if mod.nil?
            # print(from, " -", pulse == 1 ? "high" : "low", "-> ", name, "\n")
            if mod[:type] == "%"
                # print(name, " received ", pulse, "\n")
                if pulse == 0
                    mod[:state] = (mod[:state] + 1) % 2
                    mod[:dests].each { |dest| stack << [dest, mod[:state], name ]}
                end
            elsif mod[:type] == "&"
                
                mod[:state][from] = pulse
                # print(name, " received ", pulse, "- ", mod[:state], "\n")
                new_pulse = pulse == 1 && mod[:state].values.all?{_1 == 1} ? 0 : 1
                mod[:dests].each { |dest| stack << [dest, new_pulse, name ]}
            elsif mod[:type] == nil
                # Broadcaster!
                mod[:dests].each { |dest| stack << [dest, pulse, name ]}
            end
        end
    end
end


p(combination_map.values.reduce(1, :lcm))


