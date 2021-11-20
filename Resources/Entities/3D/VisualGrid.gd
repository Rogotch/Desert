extends MeshInstance


var Speed        setget SetNoizeSpeed,   GetNoizeSpeed
var Offset       setget SetOffset,       GetOffset
var AlfaMultiply setget SetAlfaMultiply, GetAlfaMultiply
var GridColor    setget SetGridColor,    GetGridColor
var _shaderMaterial

var lastColor
var newColor
var changeColorFlag = false
var colorTransition = 0.0

var lastMultiply
var newMultiply
var changeMultFlag  = false
var multTransition  = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	_shaderMaterial = get_active_material(0)
	pass # Replace with function body.

#		newGrid.get_active_material(0).set_shader_param("Offset", Vector2((0 if int(CellsNum.x) % 2 == 0 else 5), (0 if int(CellsNum.y) % 2 == 0 else 5)))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if colorTransition < 1.0 && changeColorFlag:
		colorTransition += 0.01
		var colorFin = lerp(lastColor, newColor, colorTransition)
		_shaderMaterial.set_shader_param("color2", colorFin)
	elif changeColorFlag:
		changeColorFlag = false
		colorTransition = 0.0
	
	if multTransition < 1.0 && changeMultFlag:
		multTransition += 0.01
		var multFin = lerp(lastMultiply, newMultiply, multTransition)
		_shaderMaterial.set_shader_param("AlfaMult", multFin)
	elif changeMultFlag:
		changeMultFlag = false
		multTransition = 0.0
	pass

# Устанавливает скорость движения шума
func SetNoizeSpeed(speed : float):
	_shaderMaterial.set_shader_param("speed", speed)
	pass

# Возвращает скорость движения шума
func GetNoizeSpeed():
	return _shaderMaterial.get_shader_param("speed")
	pass

# Устанавливает сдвиг ячеек
func SetOffset(offset : Vector2):
	_shaderMaterial.set_shader_param("Offset", offset)
	pass

# Возвращает размер сдвига ячеек
func GetOffset():
	return _shaderMaterial.get_shader_param("Offset")
	pass

# Устанавливает множитель альфы мгновенно
func SetAlfaMultiply(_Multiply : float):
	_shaderMaterial.set_shader_param("AlfaMult", _Multiply)
	pass

# Устанавливает множитель альфы постепенно
func SetAlfaMultiplySmooth(_Multiply : float):
	lastMultiply = GetAlfaMultiply()
	newMultiply = _Multiply
	changeMultFlag = true
	pass

# Возвращает множитель альфы
func GetAlfaMultiply():
	return _shaderMaterial.get_shader_param("AlfaMult")
	pass

# Устанавливает цвет сетки
func SetGridColor(_Color : Color):
	_shaderMaterial.set_shader_param("color2", _Color)
	pass

# Устанавливает цвет сетки плавно
func SetGridColorSmooth(_Color : Color):
	lastColor = GetGridColor()
	newColor = _Color
	changeColorFlag = true
	pass

# Возвращает активный цвет сетки
func GetGridColor():
	return _shaderMaterial.get_shader_param("color2")
	pass
