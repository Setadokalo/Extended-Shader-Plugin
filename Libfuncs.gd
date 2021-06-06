class_name LibFuncs

class Pair:
	var one
	var two
	func _init(one_, two_) -> void:
		one = one_
		two = two_


static func create_reg_exp(string : String) -> RegEx:
	var reg_exp := RegEx.new()
	var err = reg_exp.compile(string)
	
	if err or not reg_exp.is_valid():
		printerr("'" + string + "' is not a valid regular expression!")
	
	return reg_exp


# Godot... why the fuck are you like this
static func log_b(val: float, base: float = 2) -> float:
	return log(val) / log(base)

static func gcd(a: int, b: int) -> int:
	return a if b == 0 else gcd(b, a % b)
