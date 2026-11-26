extends Button
func _on_Button_pressed():
	get_node("../Panel2").visible = !get_node("../Panel2").visible
