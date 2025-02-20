class_name PlayerCharacter
extends CharacterBody2D
var speed: float
@onready var noise_image: TextureRect = $HUD/NoiseImage
@export var sfx_footsteps: AudioStream
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var InteractDialog: Control = find_interaction_dialog('InteractDialog')
@onready var GameOver: Control = find_interaction_dialog('GameOver')
@onready var AnimatedSpritePlayer2D: AnimatedSprite2D = $%AnimPlayerSprite

var isRunning := true
var normal_speed := 30
var running_speed_multiplier := 4
var max_health := 100
var current_health := 100
var stopWhenDead := false
var noise_level := 0.0
var max_noise := 10.0
var noise_decay_rate := 0.4
var noise_increase_cooldown := 0.4
var time_since_last_noise := 0.0
var isDeadPlayer := false
var isWalking := false
var noise_textures: Array = []

func _ready():
    for i in 11:
        noise_textures.append(load("res://assets/hud/noise_%d.png" % i))
    update_noise_image()
    animation_tree.active = true
    %sfx_player.stream = null

func _physics_process(delta):
    if InteractDialog.isDialogActive:
        return

    time_since_last_noise += delta

    var direction := Vector2(
        Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
        Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
    ).normalized()

    if Input.is_action_just_pressed("switch_running"):
        isRunning = !isRunning

    speed = normal_speed * running_speed_multiplier if isRunning else normal_speed
    velocity = speed * direction

    if isDeadPlayer:
        AnimatedSpritePlayer2D.frame = 2

    if stopWhenDead:
        velocity = Vector2.ZERO

    if current_health < 1 and not isDeadPlayer:
        stopWhenDead = true
        %Sprite2D.visible = false
        AnimatedSpritePlayer2D.visible = true
        AnimatedSpritePlayer2D.play('dead')

        if AnimatedSpritePlayer2D.frame == AnimatedSpritePlayer2D.sprite_frames.get_frame_count("dead") - 1:
            AnimatedSpritePlayer2D.stop()
            isDeadPlayer = true

        GameOver.visible = true
        

    if velocity == Vector2.ZERO:
        _play_animation("Idle", true, false, false)
        _reduce_noise(delta)
    elif isRunning:
        _play_animation("Correr", false, true, false)
        animation_tree.set("parameters/Correr/blend_position", direction)
        _increase_noise(0.36)
    else:
        _play_animation("Andar", false, false, true)
        animation_tree.set("parameters/Andar/blend_position", direction)
        _increase_noise(0.06)

    move_and_slide()
    update_noise_image()

func load_sfx(sfx_to_load):
    if %sfx_player.stream != sfx_to_load:
        %sfx_player.stop()
        %sfx_player.stream = sfx_to_load

func _play_animation(anim_name: String, isIdle: bool, isRunningState: bool, isWalk: bool):	
    if isWalk and not isWalking:
        load_sfx(sfx_footsteps)
        %sfx_player.play()
    else: 
        %sfx_player.stop()

    animation_tree.get("parameters/playback").travel(anim_name)
    animation_tree.set("parameters/conditions/isIdle", isIdle)
    animation_tree.set("parameters/conditions/isRunning", isRunningState)
    animation_tree.set("parameters/conditions/isWalk", isWalk)
    isWalking = isWalk

func _increase_noise(amount: float):
    if time_since_last_noise >= noise_increase_cooldown:
        noise_level = min(noise_level + amount, max_noise)
        time_since_last_noise = 0.0

func _reduce_noise(delta):
    if noise_level > 0:
        noise_level = max(noise_level - (noise_decay_rate * delta), 0)

func update_noise_image():
    noise_image.texture = noise_textures[int(noise_level)]


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
