extends Label
func _process(delta):
	text = "You have " + str(get_node("../../../../KinematicBody2D").pts) + " points"
