extends CanvasLayer
signal escolha_feita(indice_opcao)
signal button_pressed
onready var button = $Button
onready var panel = $Panel
onready var label = $Panel/RichTextLabel
onready var vbox_container = $Panel/VBoxContainer
func _ready():
	button.hide()
	panel.hide()

func mostrar_button(mostrar: bool):
	if mostrar:
		button.show()
	else:
		button.hide()

func mostrar_dialogo(texto: String, opcoes: Array):
	button.hide()
	label.text = texto
	
	
	for child in vbox_container.get_children():
		child.queue_free()
	
	for i in range(opcoes.size()):
		var btn = Button.new()
		btn.text = opcoes[i]
		btn.connect("pressed", self, "_on_opcao_pressed", [i])
		vbox_container.add_child(btn)
	
	panel.show()

func _on_Button_pressed():
	emit_signal("button_pressed")

func _on_opcao_pressed(indice):
	panel.hide()
	emit_signal("escolha_feita", indice)


func _on_UI_button_pressed():
	pass # Replace with function body.
