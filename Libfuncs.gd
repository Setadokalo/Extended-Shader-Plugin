extends Object
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
