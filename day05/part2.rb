#!/usr/bin/env ruby

input = STDIN.read.lines(chomp: true)


RangeOffset = Struct.new(:range, :offset)

class Range
    def intersect(range_offsets)
        
        range_offsets = range_offsets
            .sort_by{_1.range.first}
            .filter{self.first < _1.range.last}
            .filter{self.last < _1.range.first}

        p("Intersect", self, "RangeOffset", range_offsets)
        # p("Ranges", range_offsets, self.last)

        index = self.first

        # new_ranges << Range.new(index, range.first - 1) if index < range.first - 1

        # Add a range from the beginning of the range, to the first range
        # new_ranges << Range.new(self.first, ranges.first.start - 1)

        new_ranges = []
        range_offsets.each do |range_offset|
            range = range_offset.range
            offset = range_offset.offset

            # First, add a range going from where the index currently is to where this starts
            new_ranges << Range.new(index, range.first - 1) if index < range.first - 1
            
            # Update the index to be either at the end of either this range, or the outer range
            index = [range.last, self.last].min - 1

            # Then add this to the list
            new_ranges << Range.new(range.first, index)
            # p("Offset", offset, Range.new(offset, offset + (index - range.first)), range.first, index)
            # new_ranges << Range.new(offset, offset + ((index + 1) - range.first))

            # # Then add a range covering where we currently are
            # new_ranges << Range.new(pos, range.first - 1) if pos < self.last
            # pos = [range.last, self.last].min + 1    
        end

        # Finally, if we haven't reached the end, add it
        new_ranges << Range.new(index + 1, self.last) if index < self.last
        # new_ranges = new_ranges.filter{_1.first != _1.last}

        p("New Ranges", new_ranges)
        new_ranges
        exit

        # p(new_ranges)
        # self.each do |v|
        # end
        # p(ranges)
    end
end

# ra = Range.new(0, 5)
# ra.intersect([
#     RangeOffset.new(Range.new(2, 4), 2),
#     # RangeOffset.new(Range.new(4, 8), 10)
# ])
# p(ra)

# exit
seeds = input.shift
    .match(/:(.*)/).to_a[1]
    .strip
    .split
    .map(&:to_i)
    .each_slice(2)
    .to_a

rounds = input
    .join("\n").strip
    .gsub(" map:\n", ":")
    .split("\n\n")
    .map do |line|
        _, map_name, mappings = line.match(/([^:]*):(.*)/m).to_a
        ranges = mappings
            .split("\n")
            .map{_1.split.map(&:to_i)}
            .map{|dst, src, len| RangeOffset.new(Range.new(src, src + len), dst)}
            # .map{|dst, src, len|[src, src + len, Range.new(src, src + len), dst]}
            # .sort_by{_1[0]}

        # p(ranges)
        # exit

        
        lambda do |check_ranges|
            return_ranges = []

            p(check_ranges)
            check_ranges.each do |check_range|
                # exit
                return_ranges << check_range.intersect(ranges)
                # So we want to take a "check_range", then intersect it with the ranges
            end
            ret = return_ranges.flatten
            p("Ret", ret)
            ret
            exit
            # p("Check Ranges", check_ranges)
            # could we just return a subset of ranges here, each to check?
            # So we'd end up returning [Range(10, 15)]
            # Can we align all the ranges in order?
            # ranges.each {|range, src, dst| return dst + (n - src) if range.include?(n)}
            # n
        end
    end


cache = Hash.new
# p(seeds)

p(seeds.size)
value = seeds.map do |start, len|
    p("Starting seed", len)
    range = Range.new(start, start + len)
    val = rounds.reduce([range]) {|acc, round| acc = round.call(acc)}
    min = val if min.nil? || val < min
    min
end

p("Val", value)
