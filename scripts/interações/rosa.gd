extends Node

@onready var findInteraction = find_interaction_dialog('InteractDialog')
@onready var chooseHud = find_interaction_dialog('chooseHud')

var data: Dictionary = {

    "rosa": {
        0: {"faceset": load("res://assets/imgs/lunaface.jpeg"),
            "title": "Luana Everest",
            "dialog": "Uma rosa!!!",
        },
        1: {"faceset": load("res://assets/imgs/lunaface.jpeg"),
            "title": "Luana Everest",
            "dialog": "Que estranho,por que uma rosa estaria aqui de todos os lugares",
        }
        ,
        2: {
            "faceset": null,
            "title": "",
            "dialog": "Gostaria de pegar a flor?",
            "option": true
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
    #chooseHud.visible = true
    print(chooseHud)
    print("Body entered:", body.name)

func find_interaction_dialog(hudName):
    var tree = get_tree()
    if not tree:
        return null

    for node in tree.get_nodes_in_group("Hud"):
        if node is Control:
            return node.get_children().filter(func(child): 
                print(child.name)
                return child.name == hudName).front() if node.get_child_count() > 0 else null

    return null

func _process(delta):
    if findInteraction.hasFlowerHud == true:
        queue_free()
