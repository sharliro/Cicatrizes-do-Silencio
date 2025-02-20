extends Node2D
class_name Level

const _DIALOG_SCREEN: PackedScene = preload("res://scenes/ui/dialog_screen.tscn")

var _dialog_data: Dictionary = {
    0: {
        "faceset": load("res://assets/hudDialog/faceset-b.png"),
        "dialog": "Sua FROUXA, é óbvio que eu sou mais gostosa!",
        "title": "Safadienha"
    },
    1: {
        "faceset": load("res://assets/hudDialog/faceset.png"),
        "dialog": "Você ficou maluca? É claro que eu que sou!",
        "title": "Frouxa"
    },
    2: {
        "faceset": load("res://assets/hudDialog/faceset-b.png"),
        "dialog": "Eu já dei para 5 garotos ao mesmo tempo, então eu ganhei!",
        "title": "Safadienha"
    },
    3: {
        "faceset": load("res://assets/hudDialog/faceset.png"),
        "dialog": "A é? então se for assim. Eu vou dar para 10 Homens negão, e aí quero ver eu não ganhar!",
        "title": "Frouxa"
    }
}

@export_category("Objects")
@export var _hud: CanvasLayer = null

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("ui_select"):
        if not _hud.has_node("DialogScreen"):
            var _new_dialog: DialogScreen = _DIALOG_SCREEN.instantiate()
            _new_dialog.name = "DialogScreen" 
            _new_dialog.data = _dialog_data
            _hud.add_child(_new_dialog)
