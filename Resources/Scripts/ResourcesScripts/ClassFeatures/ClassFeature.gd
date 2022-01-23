extends Resource

class_name ClassFeature, "res://Resources/Images/GUI/SimpleIcons/White/1x/wrench.png"

export (int) var ID
export (String) var Name
export (String) var Description

export (bool) var Active = false
export (bool) var MovementFeature
export (bool) var ModifiersFeature
export (bool) var ActionFeature
export (bool) var DeathFeature
export (bool) var HealFeature
export (bool) var DamageFeature

export (int) var MaxMovement
export (int) var MaxHealth
export (int) var ZoneCross
export (int) var MaxActionPoints

func Movement():
	pass

func Modifiers():
	pass

func AddAction():
	pass

func Death():
	pass

func Heal():
	pass

func Damage():
	pass
