input = STDIN.read.lines(chomp: true)
    .join("\n").gsub("%", "").gsub("&", "").split("\n")

chart = input.reduce([]) do |acc, line|
    src, dest = line.split(" -> ")
    dest.split(", ").each do |dest|
        acc << src + ' --> ' + dest
    end
    acc
end

print(chart.join("\n"))

# -->