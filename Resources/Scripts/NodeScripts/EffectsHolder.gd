extends Node

class_name EffectsHolder, "res://Resources/Images/GUI/SimpleIcons/Icon16.png"

#enum Type {ZONE, POSITION, CHARSACTER}
#
#var Out = false
var Effects = []
var Target  = null
var ZoneObj = null

func _init():
	pass

func _ready():
	pass

func GetEffectsInfo():
	pass

func GetEffects():
	pass

func ActivateEffectsByTriggerAndType(trigger, type):
	var effects = GetEffectsByType(type)
	for effect in effects:
		if effect.Trigger == trigger:
			if (effect.EffectTarget == Effect.Target.Team && Target.PlayerTeam == effect.PlayerEffect ||
				effect.EffectTarget == Effect.Target.Enemy && Target.PlayerTeam != effect.PlayerEffect ||
				effect.EffectTarget == Effect.Target.All):
					effect.Activate(self)
#					Activate(effect)
					Global._create_timer(effect.timeDelay)
					yield(Global, "timeout")
	pass

func ActivateEffectsByType(type):
	var effects = GetEffectsByType(type)
	for effect in effects:
		if (effect.EffectTarget == Effect.Target.Team && Target.PlayerTeam == effect.PlayerEffect ||
			effect.EffectTarget == Effect.Target.Enemy && Target.PlayerTeam != effect.PlayerEffect ||
			effect.EffectTarget == Effect.Target.All):
				effect.Activate(self)
#				Activate(effect)
				Global._create_timer(effect.timeDelay)
				yield(Global, "timeout")
	pass

func GetEffectsByType(type):
	var finalEffects = []
	for effect in Effects:
		if effect.EffectType == type:
			finalEffects.append(effect)
	return finalEffects
	pass

#func Activate(effect):
##	ZoneObj.GetZones
#	for paramMod in effect.Parameters.keys():
#		if effect.Parameters[paramMod] != 0:
#			match paramMod:
#				"Health":
#					Target.Health = effect.Parameters[paramMod]
#					pass
#				"Accuracy":
#					pass
#				"ActionPoints":
#					pass
#				"Speed":
#					pass
#
#	if !effect.permanent:
#		effect.duration -= 1
#		if effect.duration == 0:
#			Effects.remove(Effects.find(effect))
#	match effect.EffectType:
#		Effect.Type.ZONE:
#			print("Активируется зональный эффект")
#			SignalsScript.emit_signal("ZoneEffectsActivate")
#			pass
#		Effect.Type.CHARSACTER:
#			print("Активируется эффект на персонаже")
#			pass
#		Effect.Type.POSITION:
#			print("Активируется эффект на позиции")
#			pass
	pass

func DeleteAllEffectsByType(type):
	var count = 0
	for effect in Effects:
		if effect.EffectType == type:
			Effects.remove(count)
		else:
			count += 1
	pass

# Загрузка эффекта из файла по ID
func SetEffectByID(id):
	var effectParams = DataBase.GetObjFromArrByID(DataBase.Effects, id)
	var newEffect = Effect.new()
	newEffect.EffectName   = effectParams.Name
	newEffect.PlayerEffect = Target.PlayerTeam
	newEffect.Parameters   = effectParams.Effects
	newEffect.timeDelay    = effectParams.timeDelay
	if effectParams.has("TargetsZones"):
		newEffect.TargetsZones = effectParams.TargetsZones
	
	if effectParams.Duration == 0:
		newEffect.permanent = true
	else:
		newEffect.duration = effectParams.Duration
	
	match effectParams.Target:
		"Team":
			newEffect.EffectTarget = Effect.Target.Team
		"Enemy":
			newEffect.EffectTarget = Effect.Target.Enemy
		"All":
			newEffect.EffectTarget = Effect.Target.All
	match effectParams.Trigger:
		"StartTurn":
			newEffect.Trigger = Effect.ActivationTrigger.StartTurn
		"EndTurn":
			newEffect.Trigger = Effect.ActivationTrigger.EndTurn
		"StartTurnOnZone":
			newEffect.Trigger = Effect.ActivationTrigger.StartTurnOnZone
		"EndTurnOnZone":
			newEffect.Trigger = Effect.ActivationTrigger.EndTurnOnZone
		"InZone":
			newEffect.Trigger = Effect.ActivationTrigger.InZone
		"OutZone":
			newEffect.Trigger = Effect.ActivationTrigger.OutZone
		"InDistance":
			newEffect.Trigger = Effect.ActivationTrigger.InDistance
		"OutDistance":
			newEffect.Trigger = Effect.ActivationTrigger.OutDistance
		"Round":
			newEffect.Trigger = Effect.ActivationTrigger.Round
	match effectParams.Type:
		"ZONE":
			newEffect.EffectType = Effect.Type.ZONE
		"CHARACTER":
			newEffect.EffectType = Effect.Type.CHARACTER
		"POSITION":
			newEffect.EffectType = Effect.Type.POSITION
	if effectParams.has("ZoneCondition"):
		match effectParams.ZoneCondition:
			"NONE":
				newEffect.ZoneStatus = Effect.ZoneCondition.NONE
			"PLAYER":
				newEffect.ZoneStatus = Effect.ZoneCondition.PLAYER
			"ENEMY":
				newEffect.ZoneStatus = Effect.ZoneCondition.ENEMY
			"COMMON":
				newEffect.ZoneStatus = Effect.ZoneCondition.COMMON
	
	Effects.append(newEffect)
	pass
