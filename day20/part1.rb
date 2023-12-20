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

modules["button"] = {
    type: "button",
    state: 0,
}

modules["output"] = {
    type: "output",
    state: nil,
    dests: [],
    inputs: []
}


low_signals = 0
high_signals = 0

1000.times do 
    stack = [["broadcaster", "button"]]
    while (name, from = stack.shift) do
        pulse = modules[from][:state]
        low_signals += 1 if pulse == 0
        high_signals += 1 if pulse == 1
        mod = modules[name]
        next if mod.nil?

        print(from, " -", pulse == 1 ? "high" : "low", "-> ", name, "\n")
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


p(low_signals)
p(high_signals)
p(low_signals * high_signals)
    # .reduce({}) do |acc, ((type, name, dest))|
    #     dests = dest.split(", ")
    #     state = nil
    #     case type
    #     when nil
    #         acc[name] = {
    #             proc: Proc.new do |queue, pulse|
    #                 dests.each do |dest|
    #                     queue << [dest, 0, name]
    #                 end
    #             end
    #         }
    #     when "%"
    #         state = 0
    #         acc[name] = {
    #             # state: 0,
    #             proc: Proc.new do |queue, pulse|
    #                 if pulse == 0
    #                     state = (state + 1 % 2)
    #                     dests.each do |dest|
    #                         queue << [dest, state, name]
    #                     end
    #                 end
    #             end
    #         }

    #     when "&"
    #         state = {}
    #         acc[name] = {
    #             # state: {},
    #             proc: Proc.new do |queue, pulse|
    #                 if state[]
    #         }
    #     end
    #     acc
    # end
    

# p(input)


# input["broadcaster"].call
# input["broadcaster"].call

# p(input)

# % = on or off - flips value on receiving low pulse
# conjunction - needs to know about each input node (uncertainty here, does it need to know about all inputs in advance)
#             - if all values high pulse, sends low pulse, otherwise sends high pulse
# 