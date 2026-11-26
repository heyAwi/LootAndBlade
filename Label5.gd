extends Label
var level = 1
func ul():
	text = "Lv." + str(level) + (" (MAX)" if level >= 20 else "")
