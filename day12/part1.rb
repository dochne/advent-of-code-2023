#!/usr/bin/env ruby

def calculate_n(spring, regex)
    match = !!spring.match(regex)
    if !match
        # print("Spring ", spring, " failed to match\n")
        return 0
    end

    index_of = spring.index("?")
    if index_of == nil
        # print("Matches - ", spring, "\n")
        return 1
    end

    total = 0
    new_spring = spring.dup
    new_spring[index_of] = "#"
    total += calculate_n(new_spring, regex)

    new_spring[index_of] = "."
    total += calculate_n(new_spring, regex)

    total
end

input = STDIN.read.lines(chomp: true)
    .map(&:split)
    .map do |spring, format|
        regex = format
            .split(",")
            .map{"[#?]{" + _1 + "}"}
            .join("[^#]+")
            .yield_self { Regexp.new("^[^#]*" + _1 + "[^#]*$") }

        calculate_n(spring, regex)
    end
    

p(input.sum)

# #?????.???????#.??? 1,2,1,1,2,2

# # First pass - you could pad "essentials" with 
# /#.##



# .??..??...?##. 1,1,3

# # This proves the concept with "this does match", but it doesn't allow us to prove anything
# /[#?][^#]+[#?][^#]+[#?]{3}/

# // /#[^#]

# # One option is to just straight up iterate through every potential other option
# # You're looking at maybe 130,000 regex matches with some of these though
# # You could quick sort through that though maybe?