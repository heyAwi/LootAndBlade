extends ProgressBar

func _process(delta):
	var hp_ratio = value / max_value
	var hue = hp_ratio * 0.3333
	var color = Color.from_hsv(hue, 1.0, 1.0)
	get("custom_styles/fg").bg_color = color
