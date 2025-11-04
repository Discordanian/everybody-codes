class_name AoCIter extends RefCounted

## Generate all combinations of k elements from the set {0, 1, 2, ..., n-1}
## Uses lexicographic ordering to enumerate all possible combinations
## @param n: Size of the set to choose from (elements 0 through n-1)
## @param k: Number of elements to choose in each combination
## @return: Array of PackedInt32Array, each containing k indices representing one combination
##          Returns empty array if k < 0 or k > n
static func combinations(n: int, k: int) -> Array[PackedInt32Array]:
    var out: Array[PackedInt32Array] = []

    if k < 0 or k > n:
        return out # Return empty

    var idx: PackedInt32Array = PackedInt32Array()
    idx.resize(k)

    for i: int in k:
        idx[i] = i

    while true:
        out.append(idx.duplicate())

        var i2: int = k - 1

        while i2 >= 0 and idx[i2] == n - k + i2:
            i2 -= 1

        if i2 < 0:
            break

        idx[i2] += 1

        for j: int in range(i2 + 1, k):
            idx[j] = idx[j - 1] + 1

    return out

## Generate the next lexicographically greater permutation of an array in-place
## Based on https://www.geeksforgeeks.org/dsa/next-permutation/
## @param a: Array of integers to permute (modified in-place)
## @return: true if a next permutation exists and was generated, false if array is already the largest permutation
##          When false is returned, the array remains in its largest permutation state
static func next_permutation(a: Array[int]) -> bool:
    var i: int = a.size() - 2

    while i >= 0 and a[i] >= a[i + 1]:
        i -= 1

    if i < 0:
        return false

    var j: int = a.size() - 1

    while a[j] <= a[i]:
        j -= 1

    var t: int = a[i]

    a[i] = a[j]
    a[j] = t

    var l: int = i + 1
    var r: int = a.size() - 1

    while l < r:
        var t2: int = a[l]
        a[l] = a[r]
        a[r] = t2

        l += 1
        r -= 1

    return true
