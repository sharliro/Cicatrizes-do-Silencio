extends Node

@onready var findInteraction = find_interaction_dialog()

var data: Dictionary = {
  
    "escadas": {
        0: {"faceset": load("res://assets/imgs/lunaface.jpeg"),
            "title": "Luana Everest",
            "dialog": "Essas escadas parecem levar ao segundo andar",
        },
        1: {
            "faceset": load("res://assets/imgs/lunaface.jpeg"),
            "title": "Luana Everest",
            "dialog": "Mas de alguma forma eu nao consigo dar um passo sequer ao chegar perto",
        }
        ,
        2: {"faceset": load("res://assets/imgs/lunaface.jpeg"),
            "title": "Luana Everest",
            "dialog": "Parece que tem algo assustador lá em cima melhor nao ir pra la por agora",
        }
        
    }
}

func _ready():
    print(findInteraction)
    connect('body_entered', Callable(self, "_on_body_entered"))
    
func _on_body_entered(body):
    findInteraction.data = data[name]
    findInteraction.InteractionControl.visible = true
    findInteraction.onCollisionField = true
    print("Body entered:", body.name)

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
