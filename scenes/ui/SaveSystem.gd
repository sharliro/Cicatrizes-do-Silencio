extends Node

const SAVE_PATH = "user://save_game.json"

var save_data = {}

func save_game():
    var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    file.store_string(JSON.stringify(save_data, "\t"))
    file.close()
    print("Jogo salvo!")

func load_game():
    if not FileAccess.file_exists(SAVE_PATH):
        print("Nenhum jogo salvo encontrado!")
        return false

    var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
    var json_string = file.get_as_text()
    file.close()

    var json = JSON.new()
    var error = json.parse(json_string)
    
    if error == OK:
        save_data = json.data
        print("Jogo carregado!")
        return true
    else:
        print("Erro ao carregar o jogo!")
        return false
