extends KinematicBody2D

export var speed = 100
export var hp = 100
export var hpmax = 100
export var dano = 15
export var detect = 150.0
export var para = 30.0

var atkcd = false
var readypos
var morto = false
var invc = false
var dir = Vector2.ZERO

onready var hb = $Flip/hitbox
onready var col = $Flip/hitbox/CollisionShape2D
onready var anim = $Flip/AnimatedSprite
onready var player = get_node("../KinematicBody2D")
onready var npc = get_node("../StaticBody2D")
var d
func randint(a, b):
	return (randi() % (b - a + 1)) + a
func _ready():
	randomize()
	readypos = global_position
	col.disabled = true
	hb.monitoring = false
	anim.play("idle")
	d = player.expNeeded - player.xp

func _physics_process(delta):
	if morto or not player:
		return
	
	var dist = global_position.distance_to(player.global_position)
	var odist = global_position.distance_to(readypos)
	
	# se ja ta em casa
	if odist < 5.0 and dist >= detect:
		dir = Vector2.ZERO
		if not anim.animation in ["attk", "dth", "hurt"]:
			anim.play("idle")
		return
	
	if dist < detect and dist >= para:
		var dire = (player.global_position - global_position).normalized()
		dir = dire * speed
		dir = move_and_slide(dir)
	elif dist <= para:
		dir = Vector2.ZERO
		if not atkcd and not morto:
			atacar()
	elif dist >= detect:
		var dire = (readypos - global_position).normalized()
		dir = dire * speed
		dir = move_and_slide(dir)
	
	if dir!= Vector2.ZERO:
		if not anim.animation in ["attk", "dth", "hurt"]:
			anim.play("walk")
		if dir.x > 0:
			$Flip.scale.x = 1
		elif dir.x < 0:
			$Flip.scale.x = -1
func atacar():
	if atkcd or morto: return
	if not is_instance_valid(player) or not is_instance_valid(self): return
	atkcd = true
	# da o dano ANTES do yield, pra não perder
	if player.global_position.distance_to(global_position) <= para + 15:
		if player.has_method("take_damage"):
			player.take_damage(dano)
		else:
			player.hp -= dano
			if player.hp <= 0:
				if player.has_method("check_death"):
					player.check_death()
			else:
				if player.has_method("a"):
					player.a()
		print("tomou ", dano, " de dano")
	anim.play("attk")
	yield(anim, "animation_finished")
	if morto or not is_instance_valid(self): return	
	anim.play("idle")
	yield(get_tree().create_timer(1.0), "timeout")
	if morto or not is_instance_valid(self):
		return
	atkcd = false
func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		if not atkcd:
			atacar()
			body.a()
			print("tomou ", dano, " de dano")
			body.check_death()
func ghit(dmg):
	if morto or invc:
		return
	hp -= dmg
	if hp <= 0:
		morrer()
	else:
		invc = true
		anim.play("hurt")
		yield(anim, "animation_finished")
		anim.play("idle")
		invc = false
func morrer():
	print("[BATTLE] Orc defeated")
	morto = true
	anim.play("dth")
	col.set_deferred("disabled", true)
	hb.set_deferred("monitoring", false)
	player.xp += randint(15, 30)
	player.gold += randint(5, 15)
	if npc and npc.get("m") == 1:
		npc.mn += 1
		if npc.mn >= 5:
			npc.m = 0
			npc.mn = 0
			player.xp += 350
			player.gold += 100
			while player.xp >= player.expNeeded:
				player.xp -= player.expNeeded if player.level < 20 else d + 1
				player.level += 1 if player.level < 20 else 0
				player.pts += 3 if player.level < 20 else 0
				player.expNeeded = int(round(150 * pow(1.15, player.level - 1))) if player.level < 20 else player.expNeeded - 1

				print(player.expNeeded)
			print("[MISSION] mission completed")
	else:
		while player.xp >= player.expNeeded:
			player.xp -= player.expNeeded if player.level < 20 else d + 1
			player.level += 1 if player.level < 20 else 0
			player.pts += 3 if player.level < 20 else 0
			player.expNeeded = int(round(150 * pow(1.15, player.level - 1))) if player.level < 20 else player.expNeeded - 1

			print(player.expNeeded)
	yield(anim, "animation_finished")
	visible = false
	set_physics_process(false)
	yield(get_tree().create_timer(10.0), "timeout")
	morto = false
	hp = hpmax
	visible = true
	global_position = readypos
	set_physics_process(true)
	anim.play("idle")
func _on_AnimatedSprite_animation_finished():
	if anim.animation in ["attk", "hurt"]: anim.play("idle")
	
# Replace with function body.
func _on_hitbox_area_entered(area): pass
func _on_hitbox_area_exited(area): pass
