class_name Fractions


class Fraction:
	var num: int setget _fail
	var den: int setget _fail


	func _init(numerator: int, denominator: int = 1) -> void:
		num = numerator
		den = denominator
	
	func _fail(_new_val: int) -> void:
		assert(false, "tried to set a final value!")
		printerr("tried to set a final value")

	func _to_string() -> String:
		return "%d/%d" % [num, den]


static func simplified(f: Fraction, epsilon := 0.00001) -> Fraction:
	var s_den := 1
	var val = (f.num as float) / (f.den as float)
	print("simplifying '%d/%d' (approx. %f)" % [f.num, f.den, (f.num as float) / (f.den as float)])
	print(val * s_den)
	print(floor(val * s_den) / float(s_den))
	while abs((floor(val * s_den) / float(s_den)) - val) > epsilon:
		s_den += 1
	
	return Fraction.new(int(val * s_den), s_den)

static func from_float(f: float, epsilon := 0.00001) -> Fraction:
	var fstr = String(f)
	var split = fstr.split(".")
	assert(split.size() > 0, "float somehow stringified to nothing!")
	
	var whole := int(split[0])
	if split.size() == 1:
		return Fraction.new(whole)
	
	var fractionalstr: String = split[1]
	
	var den:  int = pow(10.0, fractionalstr.length() as float) as int
	var numr: int = whole * (den) + int(fractionalstr)
	var gcd:  int = LibFuncs.gcd(numr, den)
	den = den / gcd
	numr = numr / gcd
	if epsilon == 0.0:
		return Fraction.new(numr, den)
	return simplified(Fraction.new(numr, den), epsilon)
