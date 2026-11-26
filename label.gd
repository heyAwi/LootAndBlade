extends Node2D
onready var label = $Label
onready var tween = $Tween
func pop(txt):
	yield(get_tree(), "idle_frame")
	scale = Vector2.ZERO
	tween.interpolate_property(self, "scale", Vector2.ZERO, Vector2.ONE, 0.4, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.start()
