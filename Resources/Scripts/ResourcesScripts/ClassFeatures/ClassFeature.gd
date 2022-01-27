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

export (int) var Strength
export (int) var Dexterity
export (int) var Charisma
export (int) var Mobility
export (int) var Constitution
export (int) var Adaptivity
export (int) var Multitasking
export (int) var Inflamed

export (Array, int) var EmmitedEffects
export (Array, int) var ReceivedEffects

export (Array, Resource) var Actions

func Movement():
	pass

func Modifiers(Hero):
	Hero.Strength += Strength
	Hero.Dexterity += Dexterity
	Hero.Charisma += Charisma
	Hero.Mobility += Mobility
	Hero.Constitution += Constitution
	Hero.Adaptivity += Adaptivity
	Hero.Multitasking += Multitasking
	Hero.Inflamed += Inflamed
	pass

func AddEffects(Hero):
	Hero.RecEff.append_array(ReceivedEffects)
	Hero.EmmEff.append_array(EmmitedEffects)
	pass

func AddActions(Hero):
	Hero.Actions.append_array(Actions)
	pass

func Death():
	pass

func Heal():
	pass

func Damage():
	pass
