extends Node

class_name Effect, "res://Resources/Images/GUI/SimpleIcons/25.png"

#enum Type {POSITIVE, NEGATIVE, NEUTRAL}
enum ActivationTrigger {InZone, OutZone, StartTurnOnZone, EndTurnOnZone, StartTurn, EndTurn, Immediately, Round}
enum Target {Team, Enemy, All}
enum ZoneCondition {NONE, ENEMY, PLAYER, COMMON}
enum Type {ZONE, POSITION, CHARACTER}

export (String)            var EffectName
export (bool)              var PlayerEffect

export (Type)              var EffectType
export (ZoneCondition)     var ZoneStatus
export (ActivationTrigger) var Trigger
export (Target)            var EffectTarget
export (int)               var distance

var timeDelay
var Parameters = {Health = 0, Accuracy = 0, ActionPoints = 0, Speed = 0}
var TargetsZones

export (bool)              var permanent = false
export (int)               var duration = 1

func _ready():
	pass

func Activate(holder):
#	ZoneObj.GetZones
	for paramMod in Parameters.keys():
		if Parameters[paramMod] != 0:
			match paramMod:
				"Health":
					holder.Target.Health = Parameters[paramMod]
					pass
				"Accuracy":
					pass
				"ActionPoints":
					pass
				"Speed":
					pass
	
	if !permanent:
		duration -= 1
		if duration == 0:
			holder.Effects.remove(holder.Effects.find(self))
