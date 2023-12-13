#!/usr/bin/env ruby

class String
    def each_cons_slice(width)
        return if self.empty?
        self.size.times.reduce([]) do |acc, n|
            acc << self.slice(n, width)
        end
    end
end

MEMO = Hash.new

def memoize(key, &block)
    if !MEMO.has_key?(key)
        MEMO[key] = block.call
    end
    return MEMO[key]
end

def num_of_possibilities(spring, status, depth = 0)
    memoize(spring + status.join(",")) do
        if status.empty?
            return spring.index("#").nil? ? 1 : 0
        end

        if spring.empty?
            return 0
        end

        current_status = status.shift
        regex = Regexp.new('^[#?]{' + current_status.to_s + '}(?:[?\.]|$)')
        total = 0
        spring.each_cons_slice(current_status + 1).each_with_index do |subset, index|
            if !spring.index("#").nil? && spring.index("#") < index
                next
            end

            match = subset.match(regex)

            if match
                total += num_of_possibilities(spring[index + match[0].size..], status, depth + 2)
            end
        end

        status.unshift current_status
        total
    end
end

input = STDIN.read.lines(chomp: true)
    .map(&:split)
    .map do |spring, status|
        spring = 5.times.map{spring}.join("?")
        status = 5.times.map{status.split(",").map(&:to_i)}.flatten
        num_of_possibilities(spring, status)
    end
    
p(input.sum)
