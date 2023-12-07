#!/usr/bin/env ruby

# CARD_VALUE_MAP = Hash.new("A": 13, "K": 12, "Q": 11, "T": 10)
Hand = Struct.new(:hand, :bid, :score)


def rank(hand)
    # hand = "AKQJT"
    split_hand = hand.split("")
        .map{
            _1
            .sub("A", "14")
            .sub("K", "13")
            .sub("Q", "12")
            .sub("J", "01")
            .sub("T", "10")
            .rjust(2, "0")
        }
        
    split_hand_without_jokers = split_hand.filter{_1 != "01"}
    total_jokers = 5 - split_hand_without_jokers.size

    # Special case - if there's 5 jokers, then we're 5 of a kind
    return ("7" + split_hand.join("")).to_i if total_jokers == 5
    tally = split_hand_without_jokers.tally.values.sort.reverse
    tally[0] += total_jokers    
    
    prefix = case tally
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
