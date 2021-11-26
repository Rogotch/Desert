extends Node

class_name Effect, "res://Resources/Images/GUI/SimpleIcons/25.png"

enum Type {POSITIVE, NEGATIVE, NEUTRAL}
enum ActivationTrigger {InZone, OutZone, InDistance, OutDistance, StartTurnOnZone, EndTurnOnZone, StartTurn, EndTurn}
enum Target {Team, All}

export (String)            var EffectName
export (bool)              var PlayerEffect

export (Type)              var EffectType
export (ActivationTrigger) var Trigger
export (Target)            var EffectTarget
export (int)               var distance

export (int)               var Health
export (int)               var Accuracy
export (int)               var ActionPoints
export (int)               var Speed

export (bool)              var permanent = false
export (int)               var duration = 1


func _ready():
	pass
