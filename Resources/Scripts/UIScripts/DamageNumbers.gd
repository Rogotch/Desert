extends Control

export (NodePath) var _Label
export (NodePath) var _TweenNode
onready var TweenNode = $Tween
onready var Numbers = get_node(_Label)
#onready var TweenNode = get_node(_TweenNode)
onready var rng = RandomNumberGenerator.new()

func _ready():
#	ShowNumbers()
	pass

func ShowNumbers():
	rng.randomize()
	var randMod = (rng.randf_range(0.0, 2.0)-1.0) * 50
	print(randMod)
	TweenNode.interpolate_property(self, "rect_position:y", rect_position.y, rect_position.y - 50, 1, 
	Tween.TRANS_ELASTIC, 
	Tween.EASE_OUT)
	TweenNode.interpolate_property(self, "rect_position:x", rect_position.x, rect_position.x + randMod, 1, 
	Tween.TRANS_CIRC, 
	Tween.EASE_OUT)
#	TweenNode.interpolate_property(self, "rect_scale:y", 0, 1, 1.1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	TweenNode.start()
	yield(TweenNode, "tween_all_completed")
	TweenNode.interpolate_property(self, "rect_scale:x", 1, 0, 1.2, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	TweenNode.interpolate_property(self, "rect_scale:y", 1, 0, 1.1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	TweenNode.start()
	yield(TweenNode, "tween_all_completed")
	queue_free()
	pass
