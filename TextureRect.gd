extends TextureRect
onready var player = get_node("../../../../KinematicBody2D")
func _process(delta):
	if player.pts < 1:
		hide()
		if player.pts >= 100:
			$Label.text = "99+"
		else:
			$Label.text = str(player.pts)
