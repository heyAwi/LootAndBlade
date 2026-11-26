extends Button
onready var player = get_node("../../../../KinematicBody2D")
onready var q = get_node("../LineEdit")
func _on_Button2_pressed():
	if $Label5.level < 20 and player.pts >= 1:
		$Label5.level += 1
		player.hp += 1 * 5
		player.hpmax += 1 * 5
		player.pts -= 1
		$Label5.ul()
