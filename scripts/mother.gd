extends CharacterBody2D

var damage_counter = 2.5
@export var speed: float = 50
var player: CharacterBody2D = null
var signalSprite2D: Sprite2D = null
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var screamSound: AudioStreamPlayer2D = $ScreamSound
var direction := Vector2.ZERO
var hasDetected = false
var isHitKill = false
var canKill = false
var isNearHitKill = false
var damage_timer: float = 0
var damage_interval: float = 0.3
#0.09
var escape_attempts: int = 0
var max_escape_attempts: int = 5

var triggerSound: bool = false
var is_sound_playing: bool = false  # To track if the sound is already playing

func _ready():
    signalSprite2D = find_hud_sprite()
    player = find_player_character()
    set_collision_layer_value(1, true)
    set_collision_mask_value(1, true)
    set_collision_mask_value(2, false)

func _physics_process(delta):
    if player:
        handle_detection_and_movement(delta)
        handle_damage_application(delta)

    if triggerSound and hasDetected and !is_sound_playing:
        screamSound.play()
        is_sound_playing = true

    elif not triggerSound and is_sound_playing:
        screamSound.stop()
        is_sound_playing = false
func teleport_near_player():
    var offset = Vector2(randi_range(-40, 40), randi_range(-40, 40))
    global_position = player.global_position + offset
    isNearHitKill = true
    
func handle_detection_and_movement(delta):
    if player.noise_level >= 5:
        hasDetected = true
        if player.noise_level >= 9.5:
            if !isNearHitKill:
                teleport_near_player()
            isHitKill = true
    elif player.noise_level <= 2:
        hasDetected = false

    if hasDetected:
        print(canKill)
        if canKill:
            direction = Vector2.ZERO
            animatedSprite.play('idle')
        else:
            direction = (player.global_position - global_position).normalized()
            animatedSprite.play('walk')
        
        animatedSprite.flip_h = direction.x < 0
        
        velocity = direction * speed
        move_and_collide(velocity * delta)

        if global_position.distance_to(player.global_position) < 30:
            pass
            #_apply_damage()

    elif not hasDetected:
        velocity = Vector2.ZERO

func handle_damage_application(delta):
    if hasDetected:
        damage_timer += delta
        if damage_timer >= damage_interval and canKill:
            print('APPLYDAMAGE')
            _apply_damage()
            damage_timer = 0

func _apply_damage():
    if player:
        if isHitKill:
            player.current_health = 0
        
        if signalSprite2D:
            if player.current_health < 1:
                pass
                #player.queue_free()
                #get_tree().change_scene_to_file("res://scenes/ui/menu_tela.tscn")
            else:
                if player.current_health < 17:
                    signalSprite2D.frame = 5
                elif player.current_health < 36:
                    signalSprite2D.frame = 4
                elif player.current_health < 50:
                    signalSprite2D.frame = 3
                elif player.current_health < 67:
                    signalSprite2D.frame = 2
                elif player.current_health < 87:
                    signalSprite2D.frame = 1
                elif player.current_health <= 100:
                    signalSprite2D.frame = 0

                player.current_health -= damage_counter

func find_hud_sprite():
    for node in get_tree().get_nodes_in_group("Hud"):
        if node is Control:
            return node.get_children().filter(func(child): 
                return child is Sprite2D).front() if node.get_children() else null
    return null

func find_player_character():
    for node in get_tree().get_nodes_in_group("Characters"):
        if node.name == "Player":
            return node.get_children().filter(func(child): 
                return child is CharacterBody2D).front() if node.get_children() else null
    return null

func _on_player_detector_area_entered(area: Area2D) -> void:
    visible = true
    triggerSound = true
    canKill = true

func _on_player_detector_area_exited(area: Area2D) -> void:
    visible = false
    triggerSound = false
    canKill = false
