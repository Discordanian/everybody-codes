extends GdUnitTestSuite

# Test basic initialization
func test_init_creates_disjoint_sets() -> void:
    var uf: UnionFind = UnionFind.new(5)
    
    # Each element should be its own parent initially
    assert_bool(uf.same(0, 1)).is_false()
    assert_bool(uf.same(1, 2)).is_false()
    assert_bool(uf.same(2, 3)).is_false()
    assert_bool(uf.same(3, 4)).is_false()
    
    # Each element should be in its own set (find returns itself)
    assert_int(uf.find(0)).is_equal(0)
    assert_int(uf.find(1)).is_equal(1)
    assert_int(uf.find(2)).is_equal(2)
    assert_int(uf.find(3)).is_equal(3)
    assert_int(uf.find(4)).is_equal(4)

func test_init_single_element() -> void:
    var uf: UnionFind = UnionFind.new(1)

    assert_int(uf.find(0)).is_equal(0)

func test_init_empty() -> void:
    var uf: UnionFind = UnionFind.new(0)

    assert_bool(uf == null).is_false()
    # Should not crash, arrays should be empty

# Test find operation
func test_find_returns_self_initially() -> void:
    var uf: UnionFind = UnionFind.new(3)

    assert_int(uf.find(0)).is_equal(0)
    assert_int(uf.find(1)).is_equal(1)
    assert_int(uf.find(2)).is_equal(2)

# Test unite operation
func test_unite_two_elements() -> void:
    var uf: UnionFind = UnionFind.new(5)

    uf.unite(0, 1)
    
    # 0 and 1 should now be in the same set
    assert_bool(uf.same(0, 1)).is_true()
    
    # But they should still be separate from others
    assert_bool(uf.same(0, 2)).is_false()
    assert_bool(uf.same(1, 2)).is_false()

func test_unite_creates_transitive_connections() -> void:
    var uf: UnionFind = UnionFind.new(5)

    uf.unite(0, 1)
    uf.unite(1, 2)
    
    # All three should be connected
    assert_bool(uf.same(0, 1)).is_true()
    assert_bool(uf.same(1, 2)).is_true()
    assert_bool(uf.same(0, 2)).is_true()

func test_unite_already_connected_elements() -> void:
    var uf: UnionFind = UnionFind.new(3)

    uf.unite(0, 1)
    uf.unite(0, 1)  # Unite again
    
    # Should still be connected
    assert_bool(uf.same(0, 1)).is_true()

func test_unite_multiple_components() -> void:
    var uf: UnionFind = UnionFind.new(6)
    
    # Create component {0, 1, 2}
    uf.unite(0, 1)
    uf.unite(1, 2)
    
    # Create component {3, 4, 5}
    uf.unite(3, 4)
    uf.unite(4, 5)
    
    # Check first component
    assert_bool(uf.same(0, 1)).is_true()
    assert_bool(uf.same(1, 2)).is_true()
    assert_bool(uf.same(0, 2)).is_true()
    
    # Check second component
    assert_bool(uf.same(3, 4)).is_true()
    assert_bool(uf.same(4, 5)).is_true()
    assert_bool(uf.same(3, 5)).is_true()
    
    # Components should be separate
    assert_bool(uf.same(0, 3)).is_false()
    assert_bool(uf.same(2, 5)).is_false()

func test_unite_merges_components() -> void:
    var uf: UnionFind = UnionFind.new(6)
    
    # Create two separate components
    uf.unite(0, 1)
    uf.unite(1, 2)
    uf.unite(3, 4)
    uf.unite(4, 5)
    
    # Merge the components
    uf.unite(2, 3)
    
    # Now all should be connected
    assert_bool(uf.same(0, 5)).is_true()
    assert_bool(uf.same(1, 4)).is_true()
    assert_bool(uf.same(2, 3)).is_true()

# Test same operation
func test_same_reflexive() -> void:
    var uf: UnionFind = UnionFind.new(3)

    # Each element is in the same set as itself
    assert_bool(uf.same(0, 0)).is_true()
    assert_bool(uf.same(1, 1)).is_true()
    assert_bool(uf.same(2, 2)).is_true()

func test_same_symmetric() -> void:
    var uf: UnionFind = UnionFind.new(3)

    uf.unite(0, 1)
    
    # same() should be symmetric
    assert_bool(uf.same(0, 1)).is_true()
    assert_bool(uf.same(1, 0)).is_true()

func test_same_transitive() -> void:
    var uf: UnionFind = UnionFind.new(4)

    uf.unite(0, 1)
    uf.unite(1, 2)
    uf.unite(2, 3)
    
    # All should be in the same set
    assert_bool(uf.same(0, 3)).is_true()
    assert_bool(uf.same(1, 3)).is_true()
    assert_bool(uf.same(0, 2)).is_true()

# Test cycle detection use case
func test_cycle_detection_no_cycle() -> void:
    var uf: UnionFind = UnionFind.new(4)
    
    # Add edges 0-1, 1-2, 2-3 (forms a tree, no cycle)
    assert_bool(uf.same(0, 1)).is_false()  # No cycle before adding edge
    uf.unite(0, 1)
    
    assert_bool(uf.same(1, 2)).is_false()  # No cycle before adding edge
    uf.unite(1, 2)
    
    assert_bool(uf.same(2, 3)).is_false()  # No cycle before adding edge
    uf.unite(2, 3)

func test_cycle_detection_finds_cycle() -> void:
    var uf: UnionFind = UnionFind.new(4)
    
    # Add edges 0-1, 1-2, 2-3
    uf.unite(0, 1)
    uf.unite(1, 2)
    uf.unite(2, 3)
    
    # Now 0 and 3 are connected, so adding edge 0-3 would create a cycle
    assert_bool(uf.same(0, 3)).is_true()  # Cycle detected!

# Test path compression
func test_path_compression() -> void:
    var uf: UnionFind = UnionFind.new(5)
    
    # Create a long chain: 0-1-2-3-4
    uf.unite(0, 1)
    uf.unite(1, 2)
    uf.unite(2, 3)
    uf.unite(3, 4)
    
    # Find should work and compress the path
    var root: int = uf.find(0)

    assert_int(uf.find(4)).is_equal(root)
    
    # All elements should now point closer to root due to path compression
    # Verify they're all still in the same set
    assert_bool(uf.same(0, 4)).is_true()

# Test large dataset
func test_large_dataset() -> void:
    var n: int = 1000
    var uf: UnionFind = UnionFind.new(n)
    
    # Connect every even number to 0
    for i: int in range(0, n, 2):
        uf.unite(0, i)
    
    # Connect every odd number to 1
    for i: int in range(1, n, 2):
        uf.unite(1, i)
    
    # All even numbers should be connected
    assert_bool(uf.same(0, 500)).is_true()
    assert_bool(uf.same(100, 200)).is_true()
    
    # All odd numbers should be connected
    assert_bool(uf.same(1, 501)).is_true()
    assert_bool(uf.same(101, 201)).is_true()
    
    # Even and odd should be separate
    assert_bool(uf.same(0, 1)).is_false()
    assert_bool(uf.same(100, 101)).is_false()
    
    # Now connect them all
    uf.unite(0, 1)
    assert_bool(uf.same(100, 101)).is_true()

# Test union by rank optimization
func test_union_by_rank_balances_trees() -> void:
    var uf: UnionFind = UnionFind.new(8)
    
    # Create two balanced trees
    uf.unite(0, 1)
    uf.unite(2, 3)
    uf.unite(0, 2)  # Now {0,1,2,3}
    
    uf.unite(4, 5)
    uf.unite(6, 7)
    uf.unite(4, 6)  # Now {4,5,6,7}
    
    # Merge the two trees
    uf.unite(0, 4)
    
    # All should be connected
    assert_bool(uf.same(1, 7)).is_true()
    assert_bool(uf.same(0, 6)).is_true()
