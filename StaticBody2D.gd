extends StaticBody2D

var jogador_perto = false
var etapa_dialogo = 0
var m
var mn = 0
onready var player = get_node("../KinematicBody2D")
func _ready():
	print("[LOG] game started")
# warning-ignore:return_value_discarded
	$Area2D.connect("body_entered", self, "_on_Area2D_body_entered")
# warning-ignore:return_value_discarded
	$Area2D.connect("body_exited", self, "_on_Area2D_body_exited")

func _unhandled_input(event):
	if jogador_perto and event.is_action_pressed("enter"):
		iniciar_dialogo()

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		print("[COLLISON] player entered npc's dialog area")
		jogador_perto = true
		var ui = get_tree().current_scene.get_node_or_null("UI")
		if ui:
			ui.mostrar_button(true)
			if not ui.is_connected("button_pressed", self, "iniciar_dialogo"):
				ui.connect("button_pressed", self, "iniciar_dialogo")

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		print("[COLLISION] player exited npc's dialog area")
		jogador_perto = false
		etapa_dialogo = 0 # Reseta o menu para o início quando o jogador se afasta
		
		var ui = get_tree().current_scene.get_node_or_null("UI")
		if ui:
			ui.mostrar_button(false)
			if ui.is_connected("button_pressed", self, "iniciar_dialogo"):
				ui.disconnect("button_pressed", self, "iniciar_dialogo")

func iniciar_dialogo():
	if not jogador_perto:
		return
		
	var ui = get_tree().current_scene.get_node_or_null("UI")
	if not ui:
		return

	if not ui.is_connected("escolha_feita", self, "_on_resposta_escolhida"):
		ui.connect("escolha_feita", self, "_on_resposta_escolhida")
	
# warning-ignore:unused_variable
	var fala_atual = ""
# warning-ignore:unused_variable
	var respostas_atuais = []

	if etapa_dialogo == 0:
		# Menu Inicial
		print("[DIALOGUE] dialogue with mage started stage = 0")
		fala_atual = "eae... os orcs atacaram a vila e eu nao consigo conter todos, \npor favor me ajudaaa selecione uma missão"
		respostas_atuais = ["Orc [Lv. 0]", "Goblin [Lv. 10]", "esquece"]

	elif etapa_dialogo == 1:
		print("[DIALOGUE] dialogue with mage started stage = 1")
		fala_atual = "Missão: derrote 5 Orcs na floresta.\n Recompensas:\n[color=yellow]350xp[/color]\n[color=green]$150[/color]\nDeseja aceitar?"
		respostas_atuais = ["Aceitar", "esquece"]

	elif etapa_dialogo == 2:
		print("[DIALOGUE] dialogue with mage started stage = 2")
		fala_atual = "Missão: derrote 5 Goblins na floresta. \n Recompensas:\n[color=yellow]750xp[/color]\n[color=green]$350[/color]\nDeseja aceitar essa missão?"
		respostas_atuais = ["Aceitar", "esquece"]
	elif etapa_dialogo == 3:
		print("[DIALOGUE] dialogue with mage started stage = 2")
		fala_atual = "Você não tem nível o suficiente pra aceitar essa missão."
		respostas_atuais = ["tá bom", "esquece"]
	ui.visible = true
	ui.mostrar_dialogo(fala_atual, respostas_atuais)
	

func _on_resposta_escolhida(indice):
	var ui = get_tree().current_scene.get_node_or_null("UI")
	
	if ui and ui.is_connected("escolha_feita", self, "_on_resposta_escolhida"):
		ui.disconnect("escolha_feita", self, "_on_resposta_escolhida")

	# --- LOGICA DAS ESCOLHAS POR ETAPA ---

	if etapa_dialogo == 0:
		match indice:
			0: # Clicou em "Orc [Lv. 0]"
				etapa_dialogo = 1
				iniciar_dialogo()
			1: # Clicou em "Goblin [Lv. 5]"
				etapa_dialogo = 2
				iniciar_dialogo()
			2: # Clicou em "esquece"
				etapa_dialogo = 0
				if jogador_perto and ui:
					ui.mostrar_button(true)

	elif etapa_dialogo == 1:
		match indice:
			0: # Clicou em "Aceitar" (Orc)
				print("[MISSION] Orc mission acepted")
				m = 1
				mn = 0
				etapa_dialogo = 0
				if jogador_perto and ui:
					ui.mostrar_button(true)
			1: # Clicou em "esquece" (Volta ao menu principal)
				etapa_dialogo = 0
				iniciar_dialogo()

	elif etapa_dialogo == 2:
		match indice:
			0: # Clicou em "Aceitar" (Goblin)
				if player.level >= 10:
					print("[MISSION] Goblin mission acepted")
					m = 2
					mn = 0
					etapa_dialogo = 0
				else:
					etapa_dialogo = 3
				if jogador_perto and ui:
					ui.mostrar_button(true)
			1: # Clicou em "esquece" (Volta ao menu principal)
				etapa_dialogo = 0
				iniciar_dialogo()
	elif etapa_dialogo == 3:
		match indice:
			0: # Clicou em "tá bom" (do coisa la de level)
				etapa_dialogo = 0
				iniciar_dialogo()
			1: # Clicou em "esquece"
				etapa_dialogo = 0
