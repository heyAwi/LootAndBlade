extends CanvasLayer
onready var text = $Control/RichTextLabel
onready var bar = $Control/hp
onready var xp = $Control/xp
onready var lvl = $Control/Panel/Label
onready var hp = $Control/hp/c
onready var hpm = $Control/hp/m
onready var xpc = $Control/xp/c
onready var xpn = $Control/xp/n
onready var c = $Control/Panel2/plus/Label4
onready var player = get_node("../KinematicBody2D")
func _ready():
		text.bbcode_enabled = true
func _process(delta):
	text.bbcode_text = "[color=green]$" + str(player.gold) + "[/color]"
	bar.max_value = player.hpmax
	bar.value = player.hp
	xp.max_value = player.expNeeded
	xp.value = player.xp
	lvl.text = "Level " + str(player.level) + (" (MAX)" if player.level == 15 else "")
	hp.text = str(player.hp)
	hpm.text = str(player.hpmax)
	xpc.text = str(player.xp)
	xpn.text = str(player.expNeeded)
	c.text = "Lv." + str(c.level) + (" (MAX)" if c.level >= 20 else "")
