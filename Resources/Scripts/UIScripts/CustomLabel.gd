tool
extends Label
class_name CustomLabel

var fonts = [
	"res://Resources/Fonts/Nunito_Sans/NunitoSans-Regular.ttf",
	"res://Resources/Fonts/Nunito_Sans/NunitoSans-Black.ttf",
	"res://Resources/Fonts/Nunito_Sans/NunitoSans-BlackItalic.ttf",
	"res://Resources/Fonts/Nunito_Sans/NunitoSans-Bold.ttf",
	"res://Resources/Fonts/Nunito_Sans/NunitoSans-BoldItalic.ttf",
	"res://Resources/Fonts/Nunito_Sans/NunitoSans-ExtraBold.ttf",
	"res://Resources/Fonts/Nunito_Sans/NunitoSans-ExtraBoldItalic.ttf",
	"res://Resources/Fonts/Nunito_Sans/NunitoSans-ExtraLight.ttf",
	"res://Resources/Fonts/Nunito_Sans/NunitoSans-ExtraLightItalic.ttf",
	"res://Resources/Fonts/Nunito_Sans/NunitoSans-Italic.ttf",
	"res://Resources/Fonts/Nunito_Sans/NunitoSans-Light.ttf",
	"res://Resources/Fonts/Nunito_Sans/NunitoSans-LightItalic.ttf",
	"res://Resources/Fonts/Nunito_Sans/NunitoSans-SemiBold.ttf",
	"res://Resources/Fonts/Nunito_Sans/NunitoSans-SemiBoldItalic.ttf",
	"res://Resources/Fonts/Tupo-Vyaz/Tupo-Vyaz_Bold.ttf",
	"res://Resources/Fonts/Tupo-Vyaz/Tupo-Vyaz_Regular.ttf",
	"res://Resources/Fonts/Tupo-Vyaz/Tupo-Vyaz_Thin.ttf",
	"res://Resources/Fonts/Tupo-Vyaz/Tupo-Vyaz_VF.ttf",
	"res://Resources/Fonts/dwarven_stonecraft/DwarvenStonecraftCyr.otf",
	"res://Resources/Fonts/never_smile/NeverSmile/NeverSmile.ttf",
	"res://Resources/Fonts/rurik/Rurikvikingfont-Regular.ttf",
	"res://Resources/Fonts/skandal/Skandal.ttf",
]

#var keys = ["NunitoSans-Regular", "NunitoSans-ExtraLight", "SourceSansPro-Regular", "SourceSansPro-ExtraLight", "DwarvenStonecraftCyr", "Skandal"]
export(int) var font_size = 14          setget setFontSize
export(Color) var font_outline_color    setget SetOutlineColor
export(int)   var font_outline_size = 0 setget SetOutlineSize
export(int, 
"NunitoSans-Regular", 
"NunitoSans-Black", 
"NunitoSans-BlackItalic", 
"NunitoSans-Bold", 
"NunitoSans-BoldItalic", 
"NunitoSans-ExtraBold", 
"NunitoSans-ExtraBoldItalic", 
"NunitoSans-ExtraLight", 
"NunitoSans-ExtraLightItalic", 
"NunitoSans-Italic", 
"NunitoSans-Light", 
"NunitoSans-LightItalic", 
"NunitoSans-SemiBold", 
"NunitoSans-SemiBoldItalic", 
"Tupo-Vyaz_Bold",
"Tupo-Vyaz_Regular",
"Tupo-Vyaz_Thin",
"Tupo-Vyaz_VF",
"DwarvenStonecraftCyr",
"NeverSmile",
"Rurikvikingfont-Regular",
"Skandal"

) var type setget setFontType

var LabelText = "" setget SetLabelText, GetLabelText
var newFont = null

func SetLabelText(newText):
	text = str(newText)
	pass

func GetLabelText():
	return text
	pass

func SetOutlineColor(color):
	font_outline_color = color
	setFontParams()
	pass

func SetOutlineSize(size):
	font_outline_size = size
	setFontParams()
	pass

func setFontParams():
	if type == null:
		type = 0
	newFont = DynamicFont.new()
	newFont.outline_color = font_outline_color
	newFont.outline_size = font_outline_size
	newFont.font_data = load(fonts[type]).duplicate()
	newFont.size = font_size

	add_font_override("font", newFont)
	pass

func setFontSize(value):
	font_size = value
	setFontParams()
	pass

func setFontType(value):
	type = value
	setFontParams()
	pass

#func SetFontByName(font_name):
#	var count = 0
#	for fontName in Fonts:
#		if font_name == fontName:
#			SetFallBackFont(count)
#	var fontsArr = getFallbackList()[0]
#	Fonts = fontsArr
#	pass
#tool
#extends Label
#
#const MIN_SIZE = Vector2(100,50)
#const MIN_FONT_SIZE = 15
#
#var fonts = [
#	"res://Project/Fonts/exo_font.tres",
#	"res://Project/Fonts/Movavi_font.tres",
#]
#
#var keys = ["Exo_font", "Movavi_font"]
#export(float) var font_size = MIN_FONT_SIZE setget _set_font_size
#export(int, "Exo_font", "Movavi_font") var type setget _set_font_type
#export(Vector2) var area_size = MIN_SIZE setget _set_area_size
#export(bool) var resized setget _resized
#export var font_text = "Example" setget _set_font_text
#export (Color) var font_color = Color(1, 1, 1) setget _set_font_color
#
#var newFont = null
#
#func _ready():
#	pass
#
#func _set_font_text(value):
#	font_text = value
#	$".".text = font_text
#	_resize_font()
#	property_list_changed_notify()
#	pass
#
#func _set_font_size(value):
#	if value < MIN_FONT_SIZE:
#		value = MIN_FONT_SIZE
#
#	font_size = value
#	_set_font_mode()
#	pass
#
#func _set_font_type(value):
#	if value == null:
#		value = 0
#
#	type = value
#	_set_font_mode()
#	pass
#
#func _set_font_mode():
#	if type == null:
#		type = 0
#	newFont = load(fonts[type]).duplicate()
#	newFont.size = font_size
#
#	add_font_override("font", newFont)
#	pass
#
#func _set_area_size(value):
#	if value.x < MIN_SIZE.x:
#		value = Vector2(MIN_SIZE.x, value.y)
#	if value.y < MIN_SIZE.y:
#		value = Vector2(value.x, MIN_SIZE.y)
#	area_size = value
#	$".".set_size(value)
#	_set_font_mode()
#	pass
#
#func _resized(value):
#	resized = value
#	if resized == true:
#		_resize_font()
#	pass
#
#func _resize_font():
#	if newFont != null and autowrap == false:
#		while newFont.get_string_size($".".text).x >= area_size.x - 10 or newFont.get_string_size($".".text).y >= area_size.y - 5:
#			font_size -= 0.5
#			_set_font_mode()
#
#	elif newFont != null and autowrap == true:
#		while newFont.get_height()*get_line_count() >= area_size.y - 20:
#			font_size -= 0.5
#			_set_font_mode()
#	#Scripts.debugMsg(str(get_line_count()))
#	pass
#
#
#func _on_DefaultLabel_resized():
#	_resize_font()
#	_set_area_size(get_size())
#
#	property_list_changed_notify()
#	pass 
#
#func _set_font_color(value):
#	font_color = value
#	add_color_override("font_color", font_color)
#	pass
