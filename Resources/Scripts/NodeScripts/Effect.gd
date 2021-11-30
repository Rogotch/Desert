extends Node

class_name Effect, "res://Resources/Images/GUI/SimpleIcons/25.png"

#enum Type {POSITIVE, NEGATIVE, NEUTRAL}
enum ActivationTrigger {InZone, OutZone, InDistance, OutDistance, StartTurnOnZone, EndTurnOnZone, StartTurn, EndTurn, Immediately}
enum Target {Team, Enemy, All}
enum Type {ZONE, POSITION, CHARACTER}

export (String)            var EffectName
export (bool)              var PlayerEffect

export (Type)              var EffectType
export (ActivationTrigger) var Trigger
export (Target)            var EffectTarget
export (int)               var distance

var Parameters = {Health = 0, Accuracy = 0, ActionPoints = 0, Speed = 0}

export (bool)              var permanent = false
export (int)               var duration = 1

func _ready():
	pass
