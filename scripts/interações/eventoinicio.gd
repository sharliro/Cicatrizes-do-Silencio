extends Node

@onready var findInteraction = find_interaction_dialog()

var data: Dictionary = {
    "escadas": {
        0: {
            "faceset": load("res://assets/imgs/lunaface.jpeg"),
            "title": "Luana Everest",
            "dialog": "Essas escadas parecem levar ao segundo andar",
        },
        1: {
            "faceset": load("res://assets/imgs/lunaface.jpeg"),
            "title": "Luana Everest",
            "dialog": "Mas de alguma forma eu não consigo dar um passo sequer ao chegar perto",
        },
        2: {
            "faceset": load("res://assets/imgs/lunaface.jpeg"),
            "title": "Luana Everest",
            "dialog": "Parece que tem algo assustador lá em cima, melhor não ir pra lá por agora",
        }
    }
}

func _ready():
    # Verificar se findInteraction está correto
    if findInteraction:
        # Verificar se a propriedade InteractionControl existe
        if findInteraction.has_node("InteractionControl"):
            var interactionControl = findInteraction.get_node("InteractionControl")
            interactionControl.visible = true  # Torna o diálogo visível
            findInteraction.data = data["escadas"]  # Aqui você pode escolher o nome da chave desejada
            findInteraction.onCollisionField = true
            print("Diálogo iniciado automaticamente.")
        else:
            print("Erro: InteractionControl não encontrado.")
    else:
        print("Erro: findInteraction não encontrou o nó.")

func _on_body_entered(body):
    # Deixe vazio, pois agora o diálogo inicia automaticamente
    pass

func find_interaction_dialog():
    var tree = get_tree()
    if not tree:
        return null
                
    for node in tree.get_nodes_in_group("Hud"):
        if node is Control:
            return node.get_children().filter(func(child): 
                print(child.name)
                return child.name == "InteractDialog").front() if node.get_child_count() > 0 else null

    return null

func _process(delta):
    pass
