input = STDIN.read.lines(chomp: true)
    .join("\n").gsub("%", "").gsub("&", "").split("\n")

chart = input.reduce([]) do |acc, line|
    src, dest = line.split(" -> ")
    dest.split(", ").each do |dest|
        acc << src + ' --> ' + dest
    end
    acc
end

print("flowchart TD\n")
print("  button --> broadcaster\n    ")
print(
chart
    .sort_by!{_1.start_with?("broadcaster") ? 0 : 1}
    .join("\n    ")
)

# -->