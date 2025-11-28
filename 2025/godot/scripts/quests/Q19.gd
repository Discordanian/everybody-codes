class_name Q19 extends RefCounted

const BIG_NUMBER: int = 1234567890

func part1(data: String) -> String:
    var lines: PackedStringArray = data.split("\n")
    var r: Array[Array] = []
    
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
    

    var D: Dictionary = {} # Dictionary[int, Array]
    for row: Array in r:

        var a: int = row[0]
        var b: int = row[1]
        var c: int = row[2]
        
        if not D.has(a):
            D[a] = []
        D[a].append([b, c])
    
    # Find max key
    var e: int = 0
    for key: int in D.keys():
        if key > e:
            e = key
    
    var H: Dictionary = {} # Dictionary[int, Array[int]]
    for a: int in D.keys():
        H[a] = []
        var l: Array = D[a]
        for pair: Array in l:
            var y: int = pair[0]
            var h: int = pair[1]
            for i: int in range(y, y + h):
                H[a].append(i)
    

    var sorted_keys: Array[int] = []
    for key: int in H.keys():
        sorted_keys.append(key)
    sorted_keys.sort()
    

    var q: Dictionary = {} # Dictionary[int, int]
    q[0] = 0
    var x: int = 0
    
    for x1: int in sorted_keys:
        var q2: Dictionary = {} # Dictionary[int, int]
        var w: int = x1 - x
        x = x1
        
        var l1: Array = H[x1]
        
        for h1: int in q.keys():
            var v: int = q[h1]
            
            for h2: int in l1:
                var d: int = abs(h1 - h2)
                
                if d > w:
                    continue
                if d % 2 != w % 2:
                    continue
                
                @warning_ignore("integer_division")
                var m: int = v + (w + h2 - h1) / 2
                
                if not q2.has(h2):
                    q2[h2] = BIG_NUMBER
                q2[h2] = min(m, q2[h2])
        
        q = q2
    
    # Find minimum value
    var min_val: int = BIG_NUMBER
    for v: int in q.values():
        if v < min_val:
            min_val = v
    
    return str(min_val)


func part2(data: String) -> String:
    return part1(data)


func part3(data: String) -> String:
    return part1(data)
