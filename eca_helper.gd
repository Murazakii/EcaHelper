extends Control

var log_file:FileAccess
var position_pointeur:int

@onready var bg_color = $Bg_color
@onready var file_dialog = $FileDialog
@onready var label_compteur_sept_fetiche = $CenterContainer/HBoxContainer/LabelCompteurSeptFetiche
var compteur_sept_fetiche:int = 0 : set = _set_compteur_sept_fetiche

@onready var label_compteur_all_in = $CenterContainer/HBoxContainer/LabelCompteurAllIn
var compteur_all_in:int = 50 : set = _set_compteur_all_in

func _ready():
	if FileAccess.file_exists("C:/Users/User/AppData/Roaming/zaap/gamesLogs/wakfu/logs/wakfu_chat.log"):
		_on_file_dialog_file_selected("C:/Users/User/AppData/Roaming/zaap/gamesLogs/wakfu/logs/wakfu_chat.log")
	else:
		file_dialog.show()

func _on_file_dialog_file_selected(path):
	log_file = FileAccess.open(path, FileAccess.READ)
	log_file.seek_end()
	position_pointeur = log_file.get_position()
	while true:
		log_file = FileAccess.open(path, FileAccess.READ)
		log_file.seek(position_pointeur)
		while log_file.get_position() < log_file.get_length():
			var line = log_file.get_line()
			if line.contains("Yamisoki: Sept fétiche :"):
				compteur_sept_fetiche += 1
		position_pointeur = log_file.get_position()
		await get_tree().create_timer(0.2).timeout

func _on_file_dialog_canceled():
	get_tree().quit()

func _set_compteur_sept_fetiche(val):
	if val < 0:
		val = 0
	else:
		val = val % 6
	update_label_text(str(val))
	compteur_sept_fetiche = val

func _set_compteur_all_in(val):
	label_compteur_all_in.text = str(val) + "%"
	compteur_all_in = val

func update_label_text(new_val:String)->void:
	var new_text:String
	match new_val:
		"0":
			new_text = "BURST"
		_:
			new_text = new_val
	label_compteur_sept_fetiche.text = new_text


func _on_button_reset_pressed():
	compteur_sept_fetiche = 0
	label_compteur_sept_fetiche.text = "0"


func _on_button_plus_pressed():
	compteur_sept_fetiche += 1


func _on_button_moins_pressed():
	compteur_sept_fetiche -= 1


func _on_color_picker_color_changed(color):
	bg_color.color = color
