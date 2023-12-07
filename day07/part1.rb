#!/usr/bin/env ruby

Hand = Struct.new(:hand, :bid, :score)

def rank(hand)
    split_hand = hand.split("")
        .map{
            _1
            .sub("A", "14")
            .sub("K", "13")
            .sub("Q", "12")
            .sub("J", "11")
            .sub("T", "10")
            .rjust(2, "0")
        }
        
    prefix = case split_hand.tally.values.sort.reverse
    when [5]
        7 # full house
    when [4, 1]
        6 # four of a kind
    when [3, 2]
        5 # full house
    when [3, 1, 1]
        4 # three of a kind
    when [2, 2, 1]
        3 # two pair
    when [2, 1, 1, 1]
        2 # one pair
    when [1, 1, 1, 1, 1]
        1 # high card
    end
    (prefix.to_s + split_hand.join("")).to_i
end

value = STDIN.read.lines(chomp: true)
    .map{_1.split(" ")}
    .map{Hand.new(_1, _2.to_i, 0)}
    .each do |hand|
        hand.score = rank(hand.hand)
    end
    .sort_by{_1.score}
    .each_with_index.map do |hand, rank|
        (rank + 1) * hand.bid
    end
    .sum

p(value)
