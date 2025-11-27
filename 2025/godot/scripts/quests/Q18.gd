class_name Q18 extends RefCounted

var NodeDictionary: Dictionary = {}

var energies: Dictionary = {} 


class ECNodeConnection:
    var branch_thick: int = 0
    var key: int = 0
    
    func init(b: int, n: int) -> void:
        branch_thick = b
        key = n
        
        

class ECNode:
    extends RefCounted
    var id: int = 0
    var input: Array[ECNodeConnection]
    var thickness: int = 0
    
    func from_string(d: String) -> ECNode:
        var lines: PackedStringArray = d.split("\n")
        var n: Array[int] = ECodes.array_int_from_string(lines[0])
        assert(n.size() == 2)
        id = n[0]
        thickness = n[1]
        for l: String in lines.slice(1):
            var nn: Array[int] = ECodes.array_int_from_string(l)
            assert(nn.size() > 0)
            var ecn: ECNodeConnection = ECNodeConnection.new()
            match nn.size():
                2: ecn.init(nn[1], nn[0])
                1: ecn.init(nn[0], 0)
            input.push_back(ecn)
        return self
      
    
    func value(dict: Dictionary) -> int:
        var retval: int = 0
        if id == 0:
            return 1
        for enc: ECNodeConnection in input:
            var ecn: ECNode = dict[enc.key]
            retval += enc.branch_thick * ecn.value(dict)
        return retval
        
            
            
        

func part1(data: String) -> String:
    var plants: PackedStringArray = data.split("\n\n")
    var energies: Dictionary = {} # Dictionary[int, int]
    
    for id: int in range(plants.size()):
        var lines: PackedStringArray = plants[id].split("\n")
        var plant: String = lines[0]
        var branches: PackedStringArray = lines.slice(1)
        
   
        var thickness_regex: RegEx = RegEx.new()
        thickness_regex.compile(r"thickness (\d+)")
        var thickness_match: RegExMatch = thickness_regex.search(plant)
        var thickness: int = int(thickness_match.get_string(1))
        
        var energy: int = 0
        for branch: String in branches:
            if branch.is_empty():
                continue
            
            if "free" in branch:
                energy += 1
            else:
  
                var plant_regex: RegEx = RegEx.new()
                plant_regex.compile(r"Plant (\d+)")
                var plant_match: RegExMatch = plant_regex.search(branch)
                var to: int = int(plant_match.get_string(1))
                
           
                var thick_regex: RegEx = RegEx.new()
                thick_regex.compile(r"thickness (\d+)")
                var thick_match: RegExMatch = thick_regex.search(branch)
                var thick: int = int(thick_match.get_string(1))
                
                energy += energies.get(to, 0) * thick
        
        energies[id + 1] = energy if energy >= thickness else 0
    
    return str(energies[plants.size()])



func simulate(plants: PackedStringArray, test: Array[int]) -> int:
    for id: int in range(plants.size()):
        if id < test.size():
            energies[id + 1] = test[id]
            continue
        
        var lines: PackedStringArray = plants[id].split("\n")
        var plant: String = lines[0]
        var branches: PackedStringArray = lines.slice(1)
        
      
        var thickness_regex: RegEx = RegEx.new()
        thickness_regex.compile(r"thickness (-?\d+)")
        var thickness_match: RegExMatch = thickness_regex.search(plant)
        var thickness: int = int(thickness_match.get_string(1))
        
        var energy: int = 0
        for branch: String in branches:
            if branch.is_empty():
                continue
            
            if "free" in branch:
                energy += 1
            else:

                var plant_regex: RegEx = RegEx.new()
                plant_regex.compile(r"Plant (-?\d+)")
                var plant_match: RegExMatch = plant_regex.search(branch)
                var to: int = int(plant_match.get_string(1))
                

                var thick_regex: RegEx = RegEx.new()
                thick_regex.compile(r"thickness (-?\d+)")
                var thick_match: RegExMatch = thick_regex.search(branch)
                var thick: int = int(thick_match.get_string(1))
                
                energy += energies.get(to, 0) * thick
        
        energies[id + 1] = energy if energy >= thickness else 0
    
    return energies[plants.size()]

func part2(data: String) -> String:
    var sections: PackedStringArray = data.split("\n\n\n")
    var P: String = sections[0]
    var T: String = sections[1]
    
    var plants: PackedStringArray = P.split("\n\n")
    var tests: PackedStringArray = T.split("\n")
    
    energies.clear() 
    var total: int = 0
    
    for t: String in tests:

        var test_values: Array[int] = []
        var test_parts: PackedStringArray = t.split(" ")
        for part: String in test_parts:
            if not part.is_empty():
                test_values.append(int(part))
        
        total += simulate(plants, test_values)
    
    return str(total)


var thickness: Dictionary = {} # Dictionary[int, int]
var revgraph: Dictionary = {} # Dictionary[int, Array]
var plants_count: int = 0

func backbfs() -> Dictionary:
    var q: Array = [] # Used as deque
    q.append([plants_count, 1])
    var energies: Dictionary = {} # Dictionary[int, int]
    energies[plants_count] = 1
    
    while q.size() > 0:
        var item: Array = q.pop_front()
        var cur: int = item[0]
        var en: int = item[1]
        
        if not revgraph.has(cur):
            continue
        
        var branches: Array = revgraph[cur]
        for branch: Array in branches:
            var to: int = branch[0]
            var thick: int = branch[1]
            
            if to == -1:
                continue
            
            if not energies.has(to):
                energies[to] = 0
            energies[to] += en * thick
            q.append([to, en * thick])
    
    return energies

func simulate3(test: Array[int]) -> Dictionary:
    var energies: Dictionary = {} # Dictionary[int, int]
    
    for id: int in thickness.keys():
        if id <= test.size():
            energies[id] = test[id - 1]
            continue
        
        var energy: int = 0
        if revgraph.has(id):
            var branches: Array = revgraph[id]
            for branch: Array in branches:
                var to: int = branch[0]
                var thick: int = branch[1]
                
                if to == -1:
                    continue
                
                energy += energies.get(to, 0) * thick
        
        energies[id] = energy if energy >= thickness[id] else 0
    
    return energies

func part3(data: String) -> String:
    var sections: PackedStringArray = data.split("\n\n\n")
    var P: String = sections[0]
    var T: String = sections[1]
    
    var plants: PackedStringArray = P.split("\n\n")
    plants_count = plants.size()
    
    var tests: Array[Array] = []
    var test_lines: PackedStringArray = T.split("\n")
    for t: String in test_lines:
        var test_values: Array[int] = []
        var test_parts: PackedStringArray = t.split(" ")
        for part: String in test_parts:
            if not part.is_empty():
                test_values.append(int(part))
        tests.append(test_values)
    

    thickness.clear()
    revgraph.clear()
    
    for id: int in range(plants.size()):
        var lines: PackedStringArray = plants[id].split("\n")
        var plant: String = lines[0]
        var branches: PackedStringArray = lines.slice(1)
        

        var thickness_regex: RegEx = RegEx.new()
        thickness_regex.compile(r"thickness (-?\d+)")
        var thickness_match: RegExMatch = thickness_regex.search(plant)
        thickness[id + 1] = int(thickness_match.get_string(1))
        
        revgraph[id + 1] = []
        
        for branch: String in branches:
            if branch.is_empty():
                continue
            
            var to: int
            if "free" in branch:
                to = -1
            else:
                var plant_regex: RegEx = RegEx.new()
                plant_regex.compile(r"Plant (-?\d+)")
                var plant_match: RegExMatch = plant_regex.search(branch)
                to = int(plant_match.get_string(1))
            
            var thick_regex: RegEx = RegEx.new()
            thick_regex.compile(r"thickness (-?\d+)")
            var thick_match: RegExMatch = thick_regex.search(branch)
            var thick: int = int(thick_match.get_string(1))
            
            revgraph[id + 1].append([to, thick])
    

    var backtrack: Dictionary = backbfs()
    

    var besttest: Array[int] = []
    for i: int in range(1, tests[0].size() + 1):
        if backtrack.get(i, 0) >= 0:
            besttest.append(1)
        else:
            besttest.append(0)
    
    var bestval: int = simulate3(besttest)[plants_count]
    
    var res: int = 0
    for t: Array in tests:
        var val: int = simulate3(t)[plants_count]
        if val == 0:
            continue
        res += bestval - val
    
    return str(res)
