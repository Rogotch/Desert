extends Node

class_name EffectsHolder, "res://Resources/Images/GUI/SimpleIcons/Icon16.png"

#enum Type {ZONE, POSITION, CHARSACTER}
#
#var Out = false
var Effects = []
var Parent  = null
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
			if (effect.EffectTarget == Effect.Target.Team && Parent.PlayerTeam == effect.PlayerEffect ||
				effect.EffectTarget == Effect.Target.Enemy && Parent.PlayerTeam != effect.PlayerEffect ||
				effect.EffectTarget == Effect.Target.All):
					Activate(effect)
	pass

func ActivateEffectsByType(type):
	var effects = GetEffectsByType(type)
	for effect in effects:
		if (effect.EffectTarget == Effect.Target.Team && Parent.PlayerTeam == effect.PlayerEffect ||
			effect.EffectTarget == Effect.Target.Enemy && Parent.PlayerTeam != effect.PlayerEffect ||
			effect.EffectTarget == Effect.Target.All):
				Activate(effect)
	pass

func GetEffectsByType(type):
	var finalEffects = []
	for effect in Effects:
		if effect.EffectType == type:
			finalEffects.append(effect)
	return finalEffects
	pass

func Activate(effect):
#	ZoneObj.GetZones
	for paramMod in effect.Parameters.keys():
		if effect.Parameters[paramMod] != 0:
			match paramMod:
				"Health":
					Parent.Health += effect.Parameters[paramMod]
					pass
				"Accuracy":
					pass
				"ActionPoints":
					pass
				"Speed":
					pass
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

func SetEffectByID(id):
	var effectParams = DataBase.GetObjFromArrByID(DataBase.Effects, id)
	var newEffect = Effect.new()
	newEffect.PlayerEffect = Parent.PlayerTeam
	newEffect.Parameters   = effectParams.Effects
	newEffect.TargetsZones = effectParams.TargetsZones
	
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
	match effectParams.Type:
		"ZONE":
			newEffect.EffectType = Effect.Type.ZONE
		"CHARACTER":
			newEffect.EffectType = Effect.Type.CHARACTER
		"POSITION":
			newEffect.EffectType = Effect.Type.POSITION
	
	Effects.append(newEffect)
	pass
