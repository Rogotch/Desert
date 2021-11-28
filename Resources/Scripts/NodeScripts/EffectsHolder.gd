extends Node

class_name EffectsHolder, "res://Resources/Images/GUI/SimpleIcons/Icon16.png"

#enum Type {ZONE, POSITION, CHARSACTER}
#
#var Out = false
var Effects = []
var Parent = null

func _ready():
	pass

func GetEffectsInfo():
	pass

func GetEffects():
	pass

func ActivateEffects(trigger, type):
	var effects = GetEffectByType(type)
	for effect in effects:
		if effect.Trigger == trigger:
			Activate(effect)
	pass

func GetEffectByType(type):
	var finalEffects = []
	for effect in Effects:
		if effect.EffectType == type:
			finalEffects.append(effect)
	return finalEffects
	pass

func Activate(effect):
	match effect.EffectType:
		Effect.Type.ZONE:
			print("Активируется зональный эффект")
			pass
		Effect.Type.CHARSACTER:
			print("Активируется эффект на персонаже")
			pass
		Effect.Type.POSITION:
			print("Активируется эффект на позиции")
			pass
	pass

func SetEffectByID(id):
	var effectParams = DataBase.GetObjFromArrByID(DataBase.Effects, id)
	var newEffect = Effect.new()
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
