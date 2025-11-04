extends GdUnitTestSuite

# Helper function to create a simple adjacency list graph
func create_simple_graph() -> Dictionary[String, Array]:
    return {
        "A": ["B", "C"],
        "B": ["A", "D", "E"],
        "C": ["A", "F"],
        "D": ["B"],
        "E": ["B", "F"],
        "F": ["C", "E"]
    }


# Helper function to create a weighted graph for Dijkstra testing
func create_weighted_graph() -> Dictionary[String, Array]:
    return {
        "A": [{"v": "B", "w": 4}, {"v": "C", "w": 2}],
        "B": [{"v": "A", "w": 4}, {"v": "C", "w": 1}, {"v": "D", "w": 5}],
        "C": [{"v": "A", "w": 2}, {"v": "B", "w": 1}, {"v": "D", "w": 8}, {"v": "E", "w": 10}],
        "D": [{"v": "B", "w": 5}, {"v": "C", "w": 8}, {"v": "E", "w": 2}],
        "E": [{"v": "C", "w": 10}, {"v": "D", "w": 2}]
    }


# Helper function to create a grid graph for pathfinding tests
func create_grid_graph(width: int, height: int, blocked: Array[Vector2i] = []) -> Dictionary[Vector2i, Array]:
    var graph: Dictionary[Vector2i, Array] = {}
    var directions: Array[Vector2i] = [Vector2i(0, 1), Vector2i(1, 0), Vector2i(0, -1), Vector2i(-1, 0)]
    
    for y: int in range(height):
        for x: int in range(width):
            var pos: Vector2i = Vector2i(x, y)
            if pos in blocked:
                continue
                
            graph[pos] = []
            for dir: Vector2i in directions:
                var neighbor: Vector2i = pos + dir
                if neighbor.x >= 0 and neighbor.x < width and neighbor.y >= 0 and neighbor.y < height:
                    if neighbor not in blocked:
                        graph[pos].append(neighbor)
    
    return graph

# ===== BFS TESTS =====

# Test BFS with simple connected graph
func test_bfs_simple_graph() -> void:
    var graph: Dictionary = create_simple_graph()
    
    var next_func: Callable = func(node: Variant) -> Array[Variant]:
        var neighbors: Array[Variant] = []
        if graph.has(node):
            for neighbor: Variant in graph[node]:
                neighbors.append(neighbor)
        return neighbors
    
    var goal_func: Callable = func(node: Variant) -> bool:
        return node == "F"
    
    var distance: int = AoCGraph.bfs("A", next_func, goal_func)
    assert_int(distance).is_equal(2)  # A -> C -> F (3 steps)


# Test BFS with unreachable goal
func test_bfs_unreachable_goal() -> void:
    var graph: Dictionary = {
        "A": ["B"],
        "B": ["A"],
        "C": ["D"],
        "D": ["C"]
    }
    
    var next_func: Callable = func(node: Variant) -> Array[Variant]:
        var neighbors: Array[Variant] = []
        if graph.has(node):
            for neighbor: Variant in graph[node]:
                neighbors.append(neighbor)
        return neighbors
    
    var goal_func: Callable = func(node: Variant) -> bool:
        return node == "C"
    
    var distance: int = AoCGraph.bfs("A", next_func, goal_func)
    assert_int(distance).is_equal(-1)  # Unreachable


# Test BFS with start node as goal
func test_bfs_start_is_goal() -> void:
    var graph: Dictionary = create_simple_graph()
    
    var next_func: Callable = func(node: Variant) -> Array[Variant]:
        var neighbors: Array[Variant] = []
        if graph.has(node):
            for neighbor: Dictionary in graph[node]:
                neighbors.append(neighbor)
        return neighbors
    
    var goal_func: Callable = func(node: Variant) -> bool:
        return node == "A"
    
    var distance: int = AoCGraph.bfs("A", next_func, goal_func)
    assert_int(distance).is_equal(0)  # Start is goal


# Test BFS with grid pathfinding
func test_bfs_grid_pathfinding() -> void:
    var grid: Dictionary = create_grid_graph(5, 5, [Vector2i(2, 1), Vector2i(2, 2), Vector2i(2, 3)])
    
    var next_func: Callable = func(pos: Variant) -> Array[Variant]:
        var neighbors: Array[Variant] = []
        if grid.has(pos):
            for neighbor: Variant in grid[pos]:
                neighbors.append(neighbor)
        return neighbors
    
    var goal_func: Callable = func(pos: Variant) -> bool:
        return pos == Vector2i(4, 4)
    
    var distance: int = AoCGraph.bfs(Vector2i(0, 0), next_func, goal_func)
    assert_int(distance).is_equal(8)  # Manhattan distance with obstacle


# Test BFS with single node graph
func test_bfs_single_node() -> void:
    var next_func: Callable = func(_node: Variant) -> Array:
        return []  # No neighbors
    
    var goal_func: Callable = func(node: Variant) -> bool:
        return node == "TARGET"
    
    var distance: int = AoCGraph.bfs("SINGLE", next_func, goal_func)
    assert_int(distance).is_equal(-1)  # Can't reach target
    
    # Test when single node is the goal
    goal_func = func(node: Variant) -> bool:
        return node == "SINGLE"
    
    distance = AoCGraph.bfs("SINGLE", next_func, goal_func)
    assert_int(distance).is_equal(0)


# Test BFS with cycle in graph
func test_bfs_with_cycles() -> void:
    var graph: Dictionary = {
        "A": ["B"],
        "B": ["C"],
        "C": ["A", "D"],  # Cycle: A -> B -> C -> A
        "D": []
    }
    
    var next_func: Callable = func(node: Variant) -> Array[Variant]:
        var neighbors: Array[Variant] = []
        if graph.has(node):
            for neighbor: Variant in graph[node]:
                neighbors.append(neighbor)
        return neighbors
    
    var goal_func: Callable = func(node: Variant) -> bool:
        return node == "D"
    
    var distance: int = AoCGraph.bfs("A", next_func, goal_func)
    assert_int(distance).is_equal(3)  # A -> B -> C -> D

# ===== DIJKSTRA TESTS =====

# Test Dijkstra with simple weighted graph
func test_dijkstra_simple_weighted() -> void:
    var graph: Dictionary = create_weighted_graph()
    
    var next_costs_func: Callable = func(node: Variant) -> Array:
        if graph.has(node):
            return graph[node] 
        return []
    
    var distances: Dictionary = AoCGraph.dijkstra("A", next_costs_func)
    
    assert_int(distances["A"]).is_equal(0)
    assert_int(distances["B"]).is_equal(3)  # A -> C -> B (2 + 1 = 3)
    assert_int(distances["C"]).is_equal(2)  # A -> C (2)
    assert_int(distances["D"]).is_equal(8)  # A -> C -> B -> D (2 + 1 + 5 = 8)
    assert_int(distances["E"]).is_equal(10) # A -> C -> B -> D -> E (2 + 1 + 5 + 2 = 10)


# Test Dijkstra with disconnected graph
func test_dijkstra_disconnected() -> void:
    var graph: Dictionary = {
        "A": [{"v": "B", "w": 1}],
        "B": [{"v": "A", "w": 1}],
        "C": [{"v": "D", "w": 1}],
        "D": [{"v": "C", "w": 1}]
    }
    
    var next_costs_func: Callable = func(node: Variant) -> Array:
        if graph.has(node):
            return graph[node]
        return []
    
    var distances: Dictionary = AoCGraph.dijkstra("A", next_costs_func)
    
    assert_int(distances["A"]).is_equal(0)
    assert_int(distances["B"]).is_equal(1)
    assert_bool(distances.has("C")).is_false()  # Unreachable
    assert_bool(distances.has("D")).is_false()  # Unreachable


# Test Dijkstra with single node
func test_dijkstra_single_node() -> void:
    var next_costs_func: Callable = func(_node: Variant) -> Array:
        return []  # No neighbors
    
    var distances: Dictionary = AoCGraph.dijkstra("SINGLE", next_costs_func)
    
    assert_int(distances.size()).is_equal(1)
    assert_int(distances["SINGLE"]).is_equal(0)


# Test Dijkstra with zero-weight edges
func test_dijkstra_zero_weights() -> void:
    var graph: Dictionary = {
        "A": [{"v": "B", "w": 0}, {"v": "C", "w": 5}],
        "B": [{"v": "C", "w": 1}],
        "C": []
    }
    
    var next_costs_func: Callable = func(node: Variant) -> Array:
        if graph.has(node):
            return graph[node]
        return []
    
    var distances: Dictionary = AoCGraph.dijkstra("A", next_costs_func)
    
    assert_int(distances["A"]).is_equal(0)
    assert_int(distances["B"]).is_equal(0)  # A -> B (weight 0)
    assert_int(distances["C"]).is_equal(1)  # A -> B -> C (0 + 1 = 1)


# Test Dijkstra with large weights
func test_dijkstra_large_weights() -> void:
    var graph: Dictionary = {
        "A": [{"v": "B", "w": 1000000}, {"v": "C", "w": 1}],
        "B": [{"v": "D", "w": 1}],
        "C": [{"v": "D", "w": 1000000}],
        "D": []
    }
    
    var next_costs_func: Callable = func(node: Variant) -> Array:
        if graph.has(node):
            return graph[node]
        return []
    
    var distances: Dictionary = AoCGraph.dijkstra("A", next_costs_func)
    
    assert_int(distances["A"]).is_equal(0)
    assert_int(distances["B"]).is_equal(1000000)
    assert_int(distances["C"]).is_equal(1)
    assert_int(distances["D"]).is_equal(1000001)  # A -> B -> D


# Test Dijkstra with grid (uniform weights)
func test_dijkstra_grid_uniform_weights() -> void:
    var grid: Dictionary = create_grid_graph(3, 3)
    
    var next_costs_func: Callable = func(pos: Variant) -> Array:
        var edges: Array = []
        if grid.has(pos):
            for neighbor: Variant in grid[pos]:
                edges.append({"v": neighbor, "w": 1})
        return edges
    
    var distances: Dictionary = AoCGraph.dijkstra(Vector2i(0, 0), next_costs_func)
    
    assert_int(distances[Vector2i(0, 0)]).is_equal(0)
    assert_int(distances[Vector2i(1, 0)]).is_equal(1)
    assert_int(distances[Vector2i(2, 2)]).is_equal(4)  # Manhattan distance


# Test Dijkstra with self-loops
func test_dijkstra_self_loops() -> void:
    var graph: Dictionary = {
        "A": [{"v": "A", "w": 1}, {"v": "B", "w": 2}],  # Self-loop
        "B": [{"v": "C", "w": 1}],
        "C": []
    }
    
    var next_costs_func: Callable = func(node: Variant) -> Array:
        if graph.has(node):
            return graph[node]
        return []
    
    var distances: Dictionary = AoCGraph.dijkstra("A", next_costs_func)
    
    assert_int(distances["A"]).is_equal(0)  # Self-loop shouldn't affect shortest path
    assert_int(distances["B"]).is_equal(2)
    assert_int(distances["C"]).is_equal(3)


# Test Dijkstra performance with larger graph
func test_dijkstra_performance() -> void:
    # Create a chain graph: 0 -> 1 -> 2 -> ... -> 99
    var graph: Dictionary[int, Array] = {}
    var chain_length: int = 100
    
    for i: int in range(chain_length - 1):
        graph[i] = [{"v": i + 1, "w": 1}]
    graph[chain_length - 1] = []
    
    var next_costs_func: Callable = func(node: Variant) -> Array:
        if graph.has(node):
            return graph[node]
        return []
    
    var distances: Dictionary = AoCGraph.dijkstra(0, next_costs_func)
    
    assert_int(distances[0]).is_equal(0)
    assert_int(distances[50]).is_equal(50)
    assert_int(distances[99]).is_equal(99)
    assert_int(distances.size()).is_equal(chain_length)

# ===== INTEGRATION TESTS =====

# Test BFS and Dijkstra give same results on unweighted graph
func test_bfs_dijkstra_equivalence() -> void:
    var graph: Dictionary = create_simple_graph()
    
    # BFS setup
    var next_func: Callable = func(node: Variant) -> Array[Variant]:
        var neighbors: Array[Variant] = []
        if graph.has(node):
            for neighbor: Variant in graph[node]:
                neighbors.append(neighbor)
        return neighbors
    
    # Dijkstra setup (all weights = 1)
    var next_costs_func: Callable = func(node: Variant) -> Array:
        var edges: Array = []
        if graph.has(node):
            for neighbor: Variant in graph[node]:
                edges.append({"v": neighbor, "w": 1})
        return edges
    
    # Compare distances for each target
    var targets: Array[String] = ["B", "C", "D", "E", "F"]
    var dijkstra_distances: Dictionary = AoCGraph.dijkstra("A", next_costs_func)
    
    for target: String in targets:
        var goal_func: Callable = func(node: Variant) -> bool:
            return node == target
        
        var bfs_distance: int = AoCGraph.bfs("A", next_func, goal_func)
        var dijkstra_distance: int = dijkstra_distances.get(target, -1)
        
        if bfs_distance == -1:
            assert_bool(dijkstra_distances.has(target)).is_false()
        else:
            assert_int(bfs_distance).is_equal(dijkstra_distance)

# Test algorithms with complex state space (not just simple nodes)
func test_complex_state_space() -> void:
    # Test with Vector2i positions and direction state
    var State: Callable = func(pos: Vector2i, dir: int) -> Dictionary:
        return {"pos": pos, "dir": dir}
    
    var start_state: Dictionary = State.call(Vector2i(0, 0), 0)
    var goal_pos: Vector2i = Vector2i(2, 2)
    
    var next_func: Callable = func(state: Variant) -> Array[Variant]:
        var neighbors: Array[Variant] = []
        var pos: Vector2i = state["pos"]
        var dir: int = state["dir"]
        
        # Can move forward or turn
        var directions: Array[Vector2i] = [Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(0, -1)]
        var new_pos: Vector2i = pos + directions[dir]
        
        # Move forward (if in bounds)
        if new_pos.x >= 0 and new_pos.x <= 3 and new_pos.y >= 0 and new_pos.y <= 3:
            neighbors.append(State.call(new_pos, dir))
        
        # Turn left and right
        neighbors.append(State.call(pos, (dir + 1) % 4))
        neighbors.append(State.call(pos, (dir + 3) % 4))
        
        return neighbors
    
    var goal_func: Callable = func(state: Variant) -> bool:
        return state["pos"] == goal_pos
    
    var distance: int = AoCGraph.bfs(start_state, next_func, goal_func)
    assert_int(distance).is_greater(0)  # Should find a path
