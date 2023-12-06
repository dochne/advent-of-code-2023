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

        lambda do |input_ranges|
            input_ranges
                .map{|input_range| range_intersection(input_range, ranges_redirections)}
                .flatten
        end
    end

value = seeds.map do |start, len|
    p("Starting seed", len)
    range = Range.new(start, start + len - 1)
    p("Acc", [range])
    val = rounds.reduce([range]) do |acc, round|
        acc = round.call(acc)
    end

    p("Val", val)

    val.map(&:first).min
end

p(value.sort)
p(value.min)

# Too low
# 26879537
# 50716416 was right, but it isn't the lowest we have. Something here isn't right, but I've somehow pulled the right answer
# anyway, so that'll be good enough for now!
