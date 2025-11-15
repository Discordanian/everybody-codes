class_name ECodes extends Node
# Has to be extended from type Node to be able to do the download

const NORTH: Vector2i = Vector2i.UP
const SOUTH: Vector2i = Vector2i.DOWN
const EAST: Vector2i  = Vector2i.RIGHT
const WEST: Vector2i  = Vector2i.LEFT

const NORTHEAST: Vector2i = Vector2i.UP + Vector2i.RIGHT
const SOUTHEAST: Vector2i = Vector2i.DOWN + Vector2i.RIGHT
const NORTHWEST: Vector2i = Vector2i.UP + Vector2i.LEFT
const SOUTHWEST: Vector2i = Vector2i.DOWN + Vector2i.LEFT

const NEIGHBORS: Array[Vector2i] = [ NORTH, SOUTH, EAST, WEST ]
const DIAG_NEIGHBORS: Array[Vector2i] = [ NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST ]
const ALL_NEIGHBORS: Array[Vector2i] = [ NORTH, NORTHEAST, EAST, SOUTHEAST, SOUTH, SOUTHWEST, WEST, NORTHWEST]

## Example path given year and day
## @param y int The year
## @param d int The day
## @return String Returns a String path to the resource file for example
static func example_path(y: int, d: int, part: int) -> String:
    assert(y > 2014, "Year must be > 2014")
    assert(y < 2026, "Year must be < 2026")
    assert(d > - 1, "Day must not be negative")
    assert(d < 26, "Everybody Codes does not allow days greater than 25")
    return "user://%4d-%02d.ex%d" % [y,d, part]

## Input path given year and day
## @param y int The year
## @param d int The day
## @return String Returns a String path to the resource file for the input
static func input_path(y: int, d: int, part: int) -> String:
    assert(part > 0 && part < 4, "Part must be 1 or 2 or 3")
    assert(y > 2014, "Year must be > 2014")
    assert(y < 2026, "Year must be < 2026")
    assert(d > - 1, "Day must not be negative")
    assert(d < 26, "Everybody Codes does not allow days greater than 25")
    return "user://everybody_codes_e%4d_q%02d_p%d.txt" % [y, d, part]


## Get the dimensions of an array of an array (Assumes col count is same for all rows)
## @param data The 2d array
## @returns Vector2i with x being the row count and y being the col count
static func dimensions_of_2d_array(data: Array[Array]) -> Vector2i:
    var x: int = data.size()
    if x > 0:
        return Vector2i(x, data[0].size())
    return Vector2i(0,0)


## Takes an input string with newlines and returns a 2d character array
## @param input a string to parse
## @returns Array of Array of characters
static func string_to_2d_char_array(input: String) -> Array[Array]:
    var result: Array[Array] = []
    var lines: PackedStringArray = input.split("\n")
    
    for line: String in lines:
        var char_array: Array[String] = []
        for i: int in range(line.length()):
            char_array.append(line[i])
        result.append(char_array)
    
    return result


## Converts a single string to an array of Strings (split on newline)
## @param input: String
## @returns PackedStringArray An array of strings
static func string_to_lines(input: String) -> PackedStringArray:
    return  input.split("\n")


## Given a string returns an array of an array of numbers
## @param input The input string.
## @returns An array of array of integers.  Both positive or negative. 
static func string_to_2d_int_array(input: String) -> Array[Array]:
    var result: Array[Array] = []
    var lines: PackedStringArray = input.split("\n")
    
    for line: String in lines:
        if line.is_empty():
            continue
        
        var numbers: Array[int] = []
        var current_number: String = ""
        var is_negative: bool = false
        
        for i: int in range(line.length()):
            var c: String = line[i]
            
            # Check if it's a digit
            if c.is_valid_int():
                current_number += c
            # Check if it's a negative sign at the start of a number
            elif c == "-" and current_number.is_empty():
                is_negative = true
            else:
                # Non-numeric character - save current number if exists
                if not current_number.is_empty():
                    var num: int = int(current_number)
                    if is_negative:
                        num = -num
                    numbers.append(num)
                    current_number = ""
                    is_negative = false
        
        # Don't forget the last number in the line
        if not current_number.is_empty():
            var num: int = int(current_number)
            if is_negative:
                num = -num
            numbers.append(num)
        
        if numbers.size() > 0:
            result.append(numbers)
    
    return result
    
## Dumps contents of file to a String
## @param path String Path to file to read from
## @returns String Contents of file
static func string_from_file(path: String) -> String:
    var retval: String = ""
    if FileAccess.file_exists(path):
        var file: FileAccess = FileAccess.open(path, FileAccess.READ)
        if file:
           retval = file.get_as_text()
           file.close()
        else:
           push_error("Error reading data from " + path)
    else:
           push_warning("Path not found : " + path)
    return retval


## Returns array of integers from a string
## @param data String
## @returns Array[int]
static func array_int_from_string(data: String) -> Array[int]:
    var regex: RegEx = RegEx.new()
    regex.compile(r"-?\d+")
    
    var matches: Array[RegExMatch] = regex.search_all(data)
    var retval: Array[int] = []
    
    for match: RegExMatch in matches:
        var number: int = match.get_string().to_int()
        retval.append(number)
        
    return retval

## Transpose 2d array
## @param data Array[Array]
## @returns Array[Array] that converts rows and cols
static func transpose_2d_array(data: Array[Array]) -> Array[Array]:
    if data.is_empty() or data[0].is_empty():
        return []

    var rows: int = data.size()
    var cols: int = data[0].size()
    var retval: Array[Array] = []

    for col: int in range(cols):
        var new_row: Array = []
        for row: int in range(rows):
            new_row.append(data[row][col])
        retval.append(new_row)
    
    return retval

## Rotate 2D array 90 degrees clockwise
## @param data 2d Array
## @returns new rotated array
static func rotate_2d_array_clockwise(data: Array[Array]) -> Array[Array]:
    if data.is_empty() or data[0].is_empty():
        return []

    var rows: int = data.size()
    var cols: int = data[0].size()
    var retval: Array[Array] = []

    for col: int in range(cols):
        var new_row: Array = []
        for row: int in range(rows - 1, -1, -1):
            new_row.append(data[row][col])
        retval.append(new_row)

    return retval
