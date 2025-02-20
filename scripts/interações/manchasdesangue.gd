extends Node

@onready var findInteraction = find_interaction_dialog('InteractDialog')
@onready var chooseHud = find_interaction_dialog('chooseHud')
@onready var Interactsave = find_interaction_dialog('Interactsave')


var data: Dictionary = {

    "save": {
 
        0: {
            "faceset": null,
            "title": "",
            "dialog": "Gostaria de salvar?",
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
