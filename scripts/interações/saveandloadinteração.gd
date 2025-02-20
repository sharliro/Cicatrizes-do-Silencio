extends Control
class_name DialogScreen

var _step: float = 0.05
var _id: int = 0
var data: Dictionary = {}

@export_category("Objects")
@export var _name: Label = null
@export var _dialog: RichTextLabel = null
@export var _faceset: TextureRect = null
@onready var InteractionControl: Control = $%Interaction
@onready var savetela: Control = find_interaction_dialog('savetela', 'Hud')
@onready var chooseOptionControl: Control = find_interaction_dialog('ChooseHud', 'Hud')

    
    
    
      
    

var isDialogActive: bool = false
var onCollisionField: bool = false
var isFinalOption: bool = false

func _ready() -> void:
    InteractionControl.visible = false
    visible = false

func dialog_init() -> void:
    if data.is_empty():
        queue_free()
        return
    _id = 0
    isDialogActive = true
    visible = true
    _initialize_dialog()

func _process(_delta: float) -> void:
    if Input.is_action_pressed("interact") and onCollisionField and not isDialogActive:
        start_dialog()

    if isDialogActive:
        handle_dialog_progress()

func start_dialog() -> void:
    InteractionControl.visible = false
    dialog_init()

func handle_dialog_progress() -> void:
    if Input.is_action_pressed("ui_accept"):
        _step = 0.01 if _dialog.visible_ratio < 1 else 0.05

    if Input.is_action_just_pressed("ui_accept") and isFinalOption == false:
        _id += 1
        if _id >= data.size():
            end_dialog()
        else:
            _initialize_dialog()

func end_dialog() -> void:
    _id = 0
    if(chooseOptionControl and chooseOptionControl.visible == true):
        chooseOptionControl.visible = false
    isDialogActive = false
    visible = false
    isFinalOption = false

func _initialize_dialog() -> void:
    if _id >= data.size():
        return

    var entry = data[_id]
    var faceset_texture = entry.get("faceset", null)

    _name.text = entry.get("title", "Sem título")
    _dialog.text = entry.get("dialog", "")
    
    if entry.get('option') == true:
        var chooseHud:Control = find_interaction_dialog('ChooseHud', 'Hud')
        var buttonsControlYes: Control = find_interaction_dialog('OptionYes', 'Buttons')
        var buttonsControlNo: Control = find_interaction_dialog('OptionNo', 'Buttons')
        print(chooseHud, 'chooseHUDFOUND')
        if(buttonsControlYes and buttonsControlNo):
            buttonsControlYes.connect('pressed', Callable(self, '_on_yes_pressed'))
            buttonsControlNo.connect('pressed', Callable(self, '_on_no_pressed'))
        print(buttonsControlYes)
        isFinalOption = true
        chooseHud.visible = true
        _faceset.texture = null
        
    elif faceset_texture is Texture:
        _faceset.texture = faceset_texture

    _dialog.visible_characters = 0

    visible = true
    reveal_text()

func _on_yes_pressed():
    savetela.visible=true
    

func _on_no_pressed():
    print('PRESSED NO')
    end_dialog()
    

func reveal_text() -> void:
    while _dialog.visible_characters < len(_dialog.text):
        await get_tree().create_timer(_step).timeout
        _dialog.visible_characters += 1

func _on_fire_camp_body_exited(body) -> void:
    InteractionControl.visible = false
    onCollisionField = false

func find_interaction_dialog(hudName, group):
    var tree = get_tree()
    if not tree:
        return null

    for node in tree.get_nodes_in_group(group):
        if node is Control or node is Sprite2D:
            print(node, 'NODE FOUND')
            return node.get_children().filter(func(child): 
                print(child.name)
                return child.name == hudName).front() if node.get_child_count() > 0 else null

    return null
