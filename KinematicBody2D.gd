extends KinematicBody2D

export var speed = 200.0
export var runSpeed = 400.0
export var jump = -550
export var gravity = 1000
export var pogoForce = -450.0
export var pogoSideSpeed = 300.0
var isPogo = false
var gold = 0
var pts = 0
var hp = 100
var hpmax = 100
var readypos
var velocity = Vector2.ZERO
var idmg = 20
var bdmg = 20
var cdmg = bdmg * 1.5
var espada = "isw"
var level = 1
var xp = 0

var regen = hp / 50.0
var regen_timer = 0.0
export var expNeeded = 150

# ESTADOS - isso resolve tudo
var is_attacking = false
var is_hurt = false
var is_dead = false

onready var hb = $Flip/hitbox
onready var col = $Flip/hitbox/CollisionShape2D
onready var anim = $Flip/AnimatedSprite
onready var orc = get_node("../orc")
onready var pop = get_node("../Node2D")

func crc(dmg):
	if randf() > 0.05:
		return dmg * 1.5
	return dmg

func _ready():
	readypos = global_position
	col.disabled = true
	hb.monitoring = false

func uwd():
	if espada == "isw":
		bdmg = round(idmg)

func pogo_bounce():
	velocity.y = pogoForce
	isPogo = false

func _physics_process(delta):
	if is_dead:
		return

	# Ataque
	if Input.is_action_just_pressed("attack") and not is_attacking:
		do_attack()

	velocity.y += gravity * delta

	# Movimento - correr
	var curSpeed = speed
	if Input.is_action_pressed("dash"):
		curSpeed = runSpeed

	if Input.is_action_pressed("right"):
		velocity.x = curSpeed
		$Flip.scale.x = 1
	elif Input.is_action_pressed("left"):
		velocity.x = -curSpeed
		$Flip.scale.x = -1
	else:
		velocity.x = 0

	# Pogo
	if not is_on_floor() and Input.is_action_pressed("down") and Input.is_action_just_pressed("attack"):
		isPogo = true
		velocity.y = -pogoForce
		velocity.x = 0

	if isPogo and Input.is_action_pressed("down") and Input.is_action_pressed("right") and Input.is_action_just_pressed("attack"):
		velocity.x = pogoSideSpeed
		velocity.y = -pogoForce

	if isPogo and Input.is_action_pressed("down") and Input.is_action_pressed("left") and Input.is_action_just_pressed("attack"):
		velocity.x = -pogoSideSpeed
		velocity.y = -pogoForce

	# Pulo
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = jump
		isPogo = false
	# Soltou o espaço no meio da subida? Corta o pulo e cai na hora
	if Input.is_action_just_released("space") and velocity.y < 0:
		velocity.y *= 0.43  # 0.5 corta metade, 0.3 corta mais seco
	velocity = move_and_slide(velocity, Vector2.UP)
	if is_on_floor() and isPogo and velocity.y >= 0:
		var achou_canpogo = false
		for i in get_slide_count():
			var c = get_slide_collision(i)
			if c.collider and c.collider.is_in_group("canPogo"):
				achou_canpogo = true
		if not achou_canpogo:
			isPogo = false

	# AQUI é o único lugar que escolhe animação
	update_anim()
# PRIORIDADE: death > hurt > attack > jump/fall > run > walk > idle
func update_anim():
	var next_anim = "idle"
	
	if is_dead:
		next_anim = "dth"
	elif is_hurt:
		next_anim = "hurt"
	elif is_attacking:
		next_anim = "attk"
	elif not is_on_floor():
		if velocity.y < 0:
			next_anim = "jump"
		else:
			next_anim = "fall"
	elif velocity.x != 0:
		if Input.is_action_pressed("dash"):
			next_anim = "run"
		else:
			next_anim = "walk"
	else:
		next_anim = "idle"
	
	if anim.animation != next_anim:
		anim.play(next_anim)

func _process(delta):
	if hp < hpmax and hp > 0:
		regen_timer += delta
		if regen_timer >= 1.0:
			regen_timer -= 1.0
			hp = min(hp + regen, hpmax)

func do_attack():
	is_attacking = true
	col.disabled = false
	hb.monitoring = true
	# update_anim vai tocar o "attk" sozinho

func a():
	if is_dead:
		return
	is_hurt = true

func _on_AnimatedSprite_animation_finished():
	if anim.animation == "attk":
		is_attacking = false
		col.disabled = true
		hb.monitoring = false
	elif anim.animation == "hurt":
		is_hurt = false
	elif anim.animation == "dth":
		# espera o respawn
		pass

func respawn():
	hp = hpmax
	global_position = readypos
	is_dead = false
	is_attacking = false
	is_hurt = false
	set_physics_process(true)
	set_process(true)

func check_death():
	if hp <= 0 and not is_dead:
		is_dead = true
		print("[BATTLE] you has died")
		yield(anim, "animation_finished")
		set_physics_process(false)
		respawn()
		print("[BATTLE] respawned")

func _on_hitbox_body_entered(body):
	if isPogo and body.is_in_group("canPogo"):
		pogo_bounce()
	if body.is_in_group("orc"):
		var cr = crc(bdmg)
		body.ghit(cr)
		pop.pop(cr)
		print("[BATTLE] dealed ", bdmg, " damage")

func _on_hitbox_body_exited(body):
	pass
