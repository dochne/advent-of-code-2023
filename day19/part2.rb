#!/usr/bin/env ruby

WORKFLOWS = STDIN.read.lines(chomp: true)
    .join("\n")
    .split("\n\n")
    .map{_1.split("\n")}[0]
    .map do |workflow|
        _, name, rules, default = workflow.match(/^([^{]*){(.*),([^,]*)\}/).to_a
        [
            name,
            [
                rules.split(",")
                    .map { _1.match(/([xmas])(.)(\d*):(.*)/).to_a }
                    .map { [_2.to_sym, _3, _4.to_i, _5] },
                default
            ]
        ]
    end
    .to_h

def process_workflow(workflow_key, obj)
    if workflow_key == "A"
        return [obj]
    elsif workflow_key == "R"
        return []
    end

    rules, default = WORKFLOWS[workflow_key]

    response = rules.reduce([]) do |acc, (key, op, num, dest)|
        new_obj = obj.dup
        if op == "<"
            new_obj[key] = obj[key].min..([obj[key].max, num - 1].min)
            obj[key] = ([obj[key].min, num].max)..obj[key].max
            acc << process_workflow(dest, new_obj)
        else
            new_obj[key] = ([obj[key].min, num + 1].max)..obj[key].max
            obj[key] = obj[key].min..([obj[key].max, num].min)
            acc << process_workflow(dest, new_obj)
        end
    end
    response + process_workflow(default, obj)
end

total = process_workflow("in", {"x": 1..4000, "m": 1..4000, "a": 1..4000, "s": 1..4000})
    .flatten
    .map do |obj|
        obj.values.map{|range| (range.max + 1) - range.min }.reduce(&:*)
    end
    .sum

p(total)