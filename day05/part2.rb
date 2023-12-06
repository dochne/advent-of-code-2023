#!/usr/bin/env ruby

input = STDIN.read.lines(chomp: true)


RangeDst = Struct.new(:range, :dst)
def range_intersection(input_range, range_redirections)
    return_ranges = []
    idx = input_range.first
    start_pos = [range_redirections.first.range.first - 1, input_range.end].min
    if (idx < start_pos)
        return_ranges << Range.new(idx, start_pos)
        idx = start_pos + 1
    end

    range_redirections.each do |range_dst|
        if (range_dst.range.first > idx)
            return_ranges << Range.new(idx, range_dst.range.first - 1)
            idx = range_dst.range.first
        end

        if (input_range.first < range_dst.range.last && input_range.last > range_dst.range.first)
            min = [input_range.last, range_dst.range.last].min
            width = min - idx
            offset = range_dst.dst + idx - range_dst.range.first
            return_ranges << Range.new(offset, offset + width)
            idx = min + 1
        end


        if idx > input_range.last
            break
        end
    end

    if (idx < input_range.end)
        return_ranges << Range.new(idx, input_range.end)
    end
    return_ranges
end


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
        ranges_redirections = mappings
            .split("\n")
            .map{_1.split.map(&:to_i)}
            .map{|dst, src, len| RangeDst.new(Range.new(src, src + (len - 1)), dst)}
            .sort_by{_1.range.first}

        #     # .map{|dst, src, len|[src, src + len, Range.new(src, src + len), dst]}
        # # ranges.unshift(RangeDst.new(Range.new(0, ranges.first.range.first), 0)) if ranges.first.range.first != 0
        # idx = 0
        # ranges = ranges.reduce([]) do |acc, range_dst|
        #     acc << RangeDst.new(Range.new(idx, range_dst.range.first - 1), idx) if idx < range_dst.range.first
        #     idx = range_dst.range.last + 1
        #     acc << range_dst
        # end
        # p(ranges)
        # exit
        
        lambda do |input_ranges|
            return_ranges = []


            # p("InputRanges", input_ranges)
            # p("Redirection", ranges_redirections)
            


            # p(check_ranges)
            input_ranges.each do |input_range|
                return_ranges << range_intersection(input_range, ranges_redirections)
            end
            ret = return_ranges.flatten

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
    range = Range.new(start, start + len - 1)
    p("Acc", [range])
    rounds.reduce([range]) do |acc, round|
        acc = round.call(acc)
        p(acc)
    end.map(&:first).min
end
# Too low
# 26879537
p("Val", value.min)
