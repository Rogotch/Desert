extends Resource

class_name HeroClass, "res://Resources/Images/GUI/SimpleIcons/White/1x/massiveMultiplayer.png"

export (int) var Level
export (String) var Name
export (String) var Description

export (Array, Array, Resource) var BaseFeatures
export (Array, Array, Resource) var SelectableFeatures

var ActiveFeatures = []

export (bool) var MovementFeatures
export (bool) var ModifiersFeatures
export (bool) var ActionFeatures
export (bool) var DeathFeatures
export (bool) var HealFeatures
export (bool) var DamageFeatures

func _init():
	var count = 1
	for arr in BaseFeatures:
		if count <= Level:
			for feat in arr:
				ActiveFeatures.append(feat)
		count += 1
	count = 1
	for arr in BaseFeatures:
		if count <= Level:
			for feat in arr:
				if feat.Active:
					ActiveFeatures.append(feat)
		count += 1
	
	for feat in ActiveFeatures:
		MovementFeatures  = MovementFeatures  || feat.MovementFeature
		ModifiersFeatures = ModifiersFeatures || feat.ModifiersFeature
		ActionFeatures    = ActionFeatures    || feat.ActionFeature
		DeathFeatures     = DeathFeatures     || feat.DeathFeature
		HealFeatures      = HealFeatures      || feat.HealFeature
		DamageFeatures    = DamageFeatures    || feat.DamageFeature
	
	pass
