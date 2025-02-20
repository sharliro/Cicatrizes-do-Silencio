extends Control

var player = get_tree().get_nodes_in_group("Player")
 # Declaramos a variável sem inicializá-la

func _ready():
    player = get_tree().get_nodes_in_group("Player")  # Agora pegamos o jogador quando a cena estiver pronta




func save_game(player):
    if player.size() > 0:
        var save_data = {
            "position": {
                "x": player[0].position.x,
                "y": player[0].position.y
            },
            "health": player[0].health
        }
        var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
        file.store_string(JSON.stringify(save_data))
        file.close()
        print("Jogo salvo com sucesso!")
    else:
        print("Nenhum jogador encontrado para salvar!")
        
func save_slot_pressed():
    if player:
        save_game(player)

func _on_save_slot_1_pressed() -> void:
    save_slot_pressed()

func _on_save_02_pressed() -> void:
    save_slot_pressed()

func _on_save_03_pressed() -> void:
    save_slot_pressed()

func _on_save_04_pressed() -> void:
    save_slot_pressed()

func _on_back_pressed() -> void:
    print("🔙 Voltando ao menu de jogo...")
