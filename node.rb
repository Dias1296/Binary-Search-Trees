class Node
    include Comparable

    attr_accessor :value
    attr_accessor :left_children
    attr_accessor :right_children

    def initialize(value, left_children=nil, right_children=nil)
        @value = value
        @left_children = left_children
        @right_children = right_children
    end 

end
