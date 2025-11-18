extends RefCounted
class_name Q11

func _checksum(d: Array[int]) -> int:
    var retval: int = 0
    for idx: int in range(d.size()):
        retval += (idx + 1) * d[idx]
    return retval
    

func part1(data: String) -> String:
    var ducks: Array[int] = ECodes.array_int_from_string(data)
    
    var phase: int = 1
    var numcols: int = ducks.size()
    var counter: int = 0
    while phase == 1:
        counter += 1
        phase = 2
        for idx: int in range(numcols - 1):
            if ducks[idx] > ducks[idx+1]:
                phase = 1
                ducks[idx] -= 1
                ducks[idx+1] += 1
    while counter < 11:
        counter += 1
        for idx: int in range(numcols - 1):
            if ducks[idx] < ducks[idx+1]:
                ducks[idx] += 1
                ducks[idx+1] -= 1
    return str(_checksum(ducks))
    
    
func part2(data: String) -> String:
    var ducks: Array[int] = ECodes.array_int_from_string(data)
    var phase: int = 1
    var numcols: int = ducks.size()
    var counter: int = 0
    while phase == 1:
        counter += 1
        phase = 2
        for idx: int in range(numcols - 1):
            if ducks[idx] > ducks[idx+1]:
                phase = 1
                ducks[idx] -= 1
                ducks[idx+1] += 1
    counter -= 1
    while phase == 2:
        counter += 1
        phase = 3
        for idx: int in range(numcols - 1):
            if ducks[idx] < ducks[idx+1]:
                phase = 2
                ducks[idx] += 1
                ducks[idx+1] -= 1
    
    return str(counter - 1)

# Different tack.  Input was sorted so really only worried about time on phase 2
static func part3(data: String) -> String:
    var ducks: Array[int] = ECodes.array_int_from_string(data)
    var retval: int = 0
    var total: int = 0
    for d: int in ducks:
        total += d
    var avg: int = total / ducks.size()
    for d: int in ducks:
        if d < avg:
            retval += (avg - d)   
    return str(retval)
