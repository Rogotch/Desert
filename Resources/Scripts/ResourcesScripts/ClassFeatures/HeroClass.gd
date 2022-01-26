extends Resource

class_name HeroClass, "res://Resources/Images/GUI/SimpleIcons/White/1x/massiveMultiplayer.png"

export (int) var Level
export (String) var Name
export (String) var Description

export (Array, Array, Resource) var BaseFeatures
export (Array, Array, Resource) var SelectableFeatures

var ActiveFeatures = []
var Hero

export (bool) var MovementFeatures
export (bool) var ModifiersFeatures
export (bool) var EffectsFeatures
export (bool) var ActionFeatures
export (bool) var DeathFeatures
export (bool) var HealFeatures
export (bool) var DamageFeatures

func _init():
	pass

func SetParameters(hero):
	Hero = hero
	var count = 1
	for arr in BaseFeatures:
		if count <= Level:
			for feat in arr:
				ActiveFeatures.append(feat)
		count += 1
	count = 1
	for arr in SelectableFeatures:
		if count <= Level:
			for feat in arr:
				if feat.Active:
					ActiveFeatures.append(feat)
		count += 1
	
	for feat in ActiveFeatures:
		MovementFeatures  = MovementFeatures  || feat.MovementFeature
		ModifiersFeatures = ModifiersFeatures || feat.ModifiersFeature
		EffectsFeatures   = EffectsFeatures   || feat.EffectsFeature
		ActionFeatures    = ActionFeatures    || feat.ActionFeature
		DeathFeatures     = DeathFeatures     || feat.DeathFeature
		HealFeatures      = HealFeatures      || feat.HealFeature
		DamageFeatures    = DamageFeatures    || feat.DamageFeature
	
	pass

func set_class_features():
	set_hero_modifiers()
	set_hero_effects()
	set_hero_actions()
	pass

func set_hero_modifiers():
	for feat in ActiveFeatures:
		if feat.ModifiersFeature:
			feat.Modifiers(Hero)
	pass

func set_hero_effects():
	for feat in ActiveFeatures:
		if feat.EffectsFeature:
			feat.AddEffects(Hero)
	pass

func set_hero_actions():
	for feat in ActiveFeatures:
		if feat.EffectsFeature:
			feat.AddActions(Hero)
	pass
