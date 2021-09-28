load "node.rb"

class Tree
    def get_root
        p @root
    end

    def initialize(array_of_values=nil)
    end

    def build_tree(array_of_data)
        @data = array_of_data.sort.uniq
        @root = get_tree(array_of_data)
    end

    def insert(value_inserted, tree=@root)
        case
        when value_inserted == tree.value
            return nil
        when value_inserted < tree.value
            if tree.left_children == nil
                tree.left_children = Node.new(value_inserted)
                return
            else
                insert(value_inserted, tree.left_children)
            end
        when value_inserted > tree.value
            if tree.right_children == nil
                tree.right_children = Node.new(value_inserted)
                return
            else
                insert(value_inserted, tree.right_children)
            end
        end
    end

    def delete(value_deleted, tree=@root)
        if value_deleted == tree.value
            tree = tree.right_children if tree.left_children == nil
            tree = tree.left_children if tree.right_children == nil
            if tree.left_children != nil && tree.right_children != nil
                left_children = tree.left_children
                tree = tree.right_children
                sort_tree(tree.right_children, tree.left_children)
                tree.left_children = left_children
            end
        else
            delete(value_deleted, tree.left_children) if tree.left_children != nil
            delete(value_deleted, tree.right_children) if tree.right_children != nil
        end
    end

    def find_node(tree=@root, value_find)
        return tree if tree.value == value_find
        return nil if tree.left_children == nil && tree.right_children == nil
        left_children = find_node(tree.left_children, value_find)
        right_children = find_node(tree.right_children, value_find)
        return left_children if right_children == nil
        return right_children if left_children == nil
    end

    def level_order(tree=@root, queue = [])
        print "#{tree.value} "
        queue << tree.left_children unless tree.left_children.nil?
        queue << tree.right_children unless tree.right_children.nil?
        return if queue.empty?

        level_order(queue.shift, queue)
    end

    def inorder(tree=@root)
        return if tree.nil?

        inorder(tree.left_children)
        print "#{tree.value} "
        inorder(tree.right_children)
    end

    def preorder(tree=@root)
        return if tree.nil?

        print "#{tree.value} "
        preorder(tree.left_children)
        preorder(tree.right_children)
    end

    def postorder(tree=@root)
        return if tree.nil?

        postorder(tree.left_children)
        postorder(tree.right_children)
        print "#{tree.value} "
    end

    def height(tree=@root, counter=0)
        return 0 if tree.nil?
        left_edge = 0
        right_edge = 0
        counter++

        left_edge = height(tree.left_children, counter) if !tree.left_children.nil?
        right_edge = height(tree.right_children, counter) if !tree.right_children.nil?
        counter += left_edge if left_edge > right_edge
        counter += right_edge if right_edge > left_edge
        return counter
    end

    def depth(node=@root, parent=@root, edges=0)
        return 0 if node == parent
        return -1 if parent.nil?

        if node < parent.value
            edges += 1
            depth(node, parent.left_children, edges)
        elsif node > parent.value
            edges += 1
            depth(node, parent.right_children, edges)
        else
            edges
        end
    end

    def balanced?(node=@root)
        return true if node.nil?

        left_height = height(node.left_children)
        right_height = height(node.right_children)

        return true if (left_height - right_height).abs <= 1 && balanced?(node.left_children) && balanced?(node.right_children)

        false
    end

    def rebalance
        @data = inorder_array
        @root = build_tree(@data)
    end

    def pretty_print(node = @root, prefix = '', is_left = true)
        pretty_print(node.right_children, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_children
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
        pretty_print(node.left_children, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_children
    end

    private

    def get_tree(array_of_data)
        array_of_data = array_of_data.uniq
        case 
        when array_of_data.count() == 1
            root = Node.new(array_of_data[0])
            return root
        when array_of_data.count() == 2
            root = Node.new(array_of_data[1])
            root.left_children = build_tree(array_of_data[0,1])
            return root
        else
            array_start = 0
            array_end = array_of_data.count()-1
            return nil if array_start > array_end

            array_mid = ((array_end)/2.0).round(0, half: :up)
            root = Node.new(array_of_data[array_mid])
            root.left_children = build_tree(array_of_data[0, array_mid])
            root.right_children = build_tree(array_of_data[array_mid+1, array_mid])
            return root
        end
    end

    def sort_tree(tree=@root, value_inserted)
        return if value_inserted == nil
        if tree.left_children == nil
            tree.left_children = value_inserted
        else
            sort_tree(tree.right_children, value_inserted)
        end
    end

    def inorder_array(node=@root, array = [])
        unless node.nil?
            inorder_array(node.left_children, array)
            array << node.value
            inorder_array(node.right_children, array)
        end
        array
    end

    def inorder_array(node=@root, array=[])
        unless node.nil?
            inorder_array(node.left_children, array)
            array << node.value
            inorder_array(node.right_children, array)
        end
        array
    end
end

test_array = (Array.new(15) { rand(1..100)})
Node_Tree = Tree.new
Node_Tree.build_tree(test_array)
Node_Tree.pretty_print
p "Balanced: #{Node_Tree.balanced?}"
p "Level Order:"
p Node_Tree.level_order
p "Pre Order"
p Node_Tree.preorder
p "Post Order"
p Node_Tree.postorder
p "Inorder"
p Node_Tree.inorder
p "Add 169"
Node_Tree.insert(169)
p "Add 150"
Node_Tree.insert(150)
p "Add 175"
Node_Tree.insert(175)
p "Add 190"
Node_Tree.insert(190)
Node_Tree.pretty_print
p "Balanced: #{Node_Tree.balanced?}"
p "Rebalance"
Node_Tree.rebalance
Node_Tree.pretty_print
p "Balanced: #{Node_Tree.balanced?}"
p "Level Order:"
p Node_Tree.level_order
p "Pre Order"
p Node_Tree.preorder
p "Post Order"
p Node_Tree.postorder
p "Inorder"
p Node_Tree.inorder
