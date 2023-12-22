
class Range
    def intersect(range)
        self.last > range.first && range.last > self.first
    end
end

class Vector
    def inner_cells(vector)
        throw "Incorrect" if self.size != vector.size

        ranges = vector.size.times.map do |idx|
            min, max = [self[idx], vector[idx]].minmax
            min..max
        end

        result = []
        ranges[0].each do |n1|
            ranges[1].each do |n2|
                ranges[2].each do |n3|
                    result << Vector[n1, n2, n3]
                end
            end
        end
        result
    end
end


# v1 = Vector[0, 2, 2]
# v2 = Vector[1, 2, 4]
# p(v1.inner_cells(v2))
# exit

