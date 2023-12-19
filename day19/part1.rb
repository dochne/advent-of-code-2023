#!/usr/bin/env ruby

workflows, parts = STDIN.read.lines(chomp: true)
    .join("\n")
    .split("\n\n")
    .map{_1.split("\n")}

workflows = workflows.map do |workflow|
    _, name, rules, default = workflow.match(/^([^{]*){(.*),([^,]*)\}/).to_a
    rules = rules.split(",").map do |rule|
        _, property, operator, value, dest = rule.match(/([xmas])(.)(\d*):(.*)/).to_a
        value = value.to_i
        
        if operator == "<"
            Proc.new {|object| object[property] < value ? dest : nil}
        elsif operator == ">"
            Proc.new {|object| object[property] > value ? dest : nil}
        end
    end
    
    [
        name,
        Proc.new do |object|
            rules.reduce(nil) do |acc, rule|
                acc = rule.call(object) if acc.nil?
                acc
            end || default
        end
    ]
end.to_h

parts = parts.map{
    _1
    .sub("{", "").sub("}", "")
    .split(",")
    .map{|v| v.split("=")}
    .map{|v| [v[0], v[1].to_i]}
    .to_h
}

accepted = []
rejected = []
parts.each do |part|
    print("\nPart ", part, " -> in ")
    key = "in"
    loop {
        key = workflows[key].call(part)
        print(" -> ", key)
        if key == "A"
            accepted << part
            break
        elsif key == "R"
            rejected << part
            break
        end
    }
end

# p(accepted)

# p(rejected)
    

print("\n")
p(accepted.map{_1.values.sum}.sum)


# p(workflows)