#!/usr/bin/env ruby

result = STDIN.read.split("\n")
    .map{(/\d/.match(_1)[0] + /(\d)[^\d]*$/.match(_1)[1]).to_i}
    .sum

p(result)