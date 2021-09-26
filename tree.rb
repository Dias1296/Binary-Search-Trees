load "node.rb"

class Tree
    def get_root
        p @root
    end

    def initialize(array_of_values=nil)
    end

    def build_tree(array_of_data)
        @root = get_tree(array_of_data)
    end

    def insert(value_inserted, tree=@root)
        case
        when value_inserted == tree.value
            raise "Value already in the tree. No duplicates allowed!"
        when value_inserted < tree.value
            if tree.left_children == nil
                tree.left_children = value_inserted
                return
            else
                insert(value_inserted, tree.left_children)
            end
        when value_inserted > tree.value
            if tree.right_children == nil
                tree.right_children = value_inserted
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
        print "#{tree.value}"
        inorder(tree.right_children)
    end

    def preorder(tree=@root)
        return if tree.nil?

        print "#{tree.value}"
        preorder(tree.left_children)
        preorder(tree.right_children)
    end

    def postorder(tree=@root)
        return if tree.nil?

        postorder(tree.left_children)
        postorder(tree.right_children)
        print "#{tree.value}"
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
end

teste = Tree.new
p teste.build_tree([1,2,3,4,5,5])
teste.insert(0)
