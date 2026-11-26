extends Button
onready var player = get_node("../../../../KinematicBody2D")
onready var q = get_node("../LineEdit")
func _on_Button2_pressed():
	if $Label4.level < 20 and player.pts >= 1:
		$Label4.level += 1
		player.bdmg += 1 * 1.2
		player.pts -= 1
