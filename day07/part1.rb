#!/usr/bin/env ruby

# CARD_VALUE_MAP = Hash.new("A": 13, "K": 12, "Q": 11, "T": 10)
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
    score = (prefix.to_s + split_hand.join("")).to_i
    print(hand, "-", prefix, "-", score, "\n")
    score
end
# Five of a kind, where all five cards have the same label: AAAAA
# Four of a kind, where four cards have the same label and one card has a different label: AA8AA
# Full house, where three cards have the same label, and the remaining two cards share a different label: 23332
# Three of a kind, where three cards have the same label, and the remaining two cards are each different from any other card in the hand: TTT98
# Two pair, where two cards share one label, two other cards share a second label, and the remaining card has a third label: 23432
# One pair, where two cards share one label, and the other three cards have a different label from the pair and each other: A23A4
# High card, where all cards' labels are distinct: 23456

# rank(["03","02","10","03","13"])


# exit
value = STDIN.read.lines(chomp: true)
    .map{_1.split(" ")}
    .map{Hand.new(_1, _2.to_i, 0)}
    .each do |hand|
        # hand.hand = hand.hand
        #     .split("")
        #     .map{
        #         _1
        #         .sub("A", "14")
        #         .sub("K", "13")
        #         .sub("Q", "12")
        #         .sub("J", "11")
        #         .sub("T", "10")
        #         .rjust(2, "0")
        #     }
        hand.score = rank(hand.hand)
    end
    .sort_by{_1.score}
    # .reverse
    .each_with_index.map do |hand, rank|
        print(
            hand.hand, ": ",
            hand.bid.to_s.rjust(3, " "),
            " - ",
            rank + 1,
            " - ",
            ((rank + 1) * hand.bid).to_s.rjust(4, " "),
            " - ",
            hand.score,
            "\n"
        )
        (rank + 1) * hand.bid
    end
    .sum

p(value)
