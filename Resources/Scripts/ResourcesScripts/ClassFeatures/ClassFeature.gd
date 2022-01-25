extends Resource

class_name ClassFeature, "res://Resources/Images/GUI/SimpleIcons/White/1x/wrench.png"

export (int) var ID
export (String) var Name
export (String) var Description

export (bool) var Active = false
export (bool) var MovementFeature
export (bool) var ModifiersFeature
export (bool) var EffectsFeature
export (bool) var ActionFeature
export (bool) var DeathFeature
export (bool) var HealFeature
export (bool) var DamageFeature

export (int) var MaxMovement
export (int) var MaxHealth
export (int) var ZoneCross
export (int) var MaxActionPoints

export (Array, int) var EmmitedEffects
export (Array, int) var ReceivedEffects

func Movement():
	pass

func Modifiers(Hero):
	Hero.MaxMovement += MaxMovement
	Hero.MaxHealth += MaxHealth
	Hero.ZoneCross += ZoneCross
	Hero.MaxActionPoints += MaxActionPoints
	pass

func AddEffects(Hero):
	Hero.RecEff.append_array(ReceivedEffects)
	Hero.EmmEff.append_array(EmmitedEffects)
	pass

func AddAction():
	pass

func Death():
	pass

func Heal():
	pass

func Damage():
	pass
