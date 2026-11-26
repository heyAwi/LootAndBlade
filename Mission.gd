extends Panel
onready var m = $m
onready var rw = $rw
onready var cm = $cm
onready var s = $s
onready var xp = $xp
onready var img = $oimg
var path = "res://assets/chars/Tiny RPG Character Asset Pack 01 v2.0 -Free Soldier&Orc/Characters(100x100 split)/Orc/Orc/Orc_profile.png"
var gpath = "res://assets/chars/Tiny RPG Character Asset Pack 01 v2.0 -Free Soldier&Orc/Characters(100x100 split)/Goblin/Goblin_Profile.png"
onready var npc = get_node("../../../StaticBody2D")
onready var plr = get_node("../../../KinematicBody2D")
func _process(delta):
	match npc.m:
		1:
			m.text = "Defeat 5 Orcs (" + str(npc.mn) + "/" + str(5) + ")"
			xp.text = "350xp"
			s.text = "$150"
			m.visible = true
			rw.visible = true
			cm.visible = true
			s.visible = true
			xp.visible = true
			visible = true
			img.visible = true
			img.texture = load(path)
		2:
			m.text = "Defeat 5 Goblins (" + str(npc.mn) + "/" + str(5) + ")"
			xp.text = "750xp"
			s.text = "$350"
			m.visible = true
			rw.visible = true
			cm.visible = true
			s.visible = true
			xp.visible = true
			visible = true
			img.visible = true
			img.texture = load(gpath)
		_:
			m.visible = false
			rw.visible = false
			cm.visible = false
			s.visible = false
			xp.visible = false
			visible = false
			img.visible = false
