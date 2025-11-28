class_name Q19 extends RefCounted

func part1(data: String) -> String:
    var lines: PackedStringArray = data.split("\n")
    var r: Array[Array] = []
    
    # Parse input
    var regex: RegEx = RegEx.new()
    regex.compile(r"-?\d+")
    
    for l: String in lines:
        if l.is_empty():
            continue
        var matches: Array[RegExMatch] = regex.search_all(l)
        var nums: Array[int] = []
        for match: RegExMatch in matches:
            nums.append(int(match.get_string()))
        if nums.size() > 0:
            r.append(nums)
    
    # Build D dictionary
    var D: Dictionary = {} # Dictionary[int, Array]
    for row: Array in r:
        var row_arr: Array = row as Array
        var a: int = row_arr[0]
        var b: int = row_arr[1]
        var c: int = row_arr[2]
        
        if not D.has(a):
            D[a] = []
        D[a].append([b, c])
    
    # Find max key
    var e: int = 0
    for key: int in D.keys():
        var k: int = key as int
        if k > e:
            e = k
    
    # Build H dictionary (height ranges)
    var H: Dictionary = {} # Dictionary[int, Array[int]]
    for a_int: int in D.keys():
        # var a_int: int = a as int
        H[a_int] = []
        var l: Array = D[a_int]
        for item: Array in l:
            var pair: Array = item as Array
            var y: int = pair[0]
            var h: int = pair[1]
            for i: int in range(y, y + h):
                H[a_int].append(i)
    
    # Sort keys for iteration
    var sorted_keys: Array[int] = []
    for key: int in H.keys():
        sorted_keys.append(key as int)
    sorted_keys.sort()
    
    # Dynamic programming
    var q: Dictionary = {} # Dictionary[int, int]
    q[0] = 0
    var x: int = 0
    
    for x1: int in sorted_keys:
        var q2: Dictionary = {} # Dictionary[int, int]
        var w: int = x1 - x
        x = x1
        
        var l1: Array = H[x1]
        
        for h1: int in q.keys():
            var h1_int: int = h1 as int
            var v: int = q[h1_int]
            
            for h2_var: int in l1:
                var h2: int = h2_var as int
                var d: int = abs(h1_int - h2)
                
                if d > w:
                    continue
                if d % 2 != w % 2:
                    continue
                
                @warning_ignore("integer_division")
                var m: int = v + (w + h2 - h1_int) / 2
                
                if not q2.has(h2):
                    q2[h2] = 1000000000
                q2[h2] = min(m, q2[h2])
        
        q = q2
    
    # Find minimum value
    var min_val: int = 1000000000
    for val: int in q.values():
        var v: int = val as int
        if v < min_val:
            min_val = v
    
    return str(min_val)


func part2(data: String) -> String:
    return part1(data)


func part3(data: String) -> String:
    return part1(data)
