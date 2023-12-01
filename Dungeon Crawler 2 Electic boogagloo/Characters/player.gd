extends CharacterBody2D

signal Player_Is_Attacking


@export var move_speed: float = 300
@export var starting_direction: Vector2 = Vector2(0, 0.5)
@export var player_health: float = 100
# parameters/Idle/blend_position
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
var enemy_is_attacking = false
var is_not_detected = false
var animation_player : AnimationPlayer
var player_is_attacking = false
var can_quit = false
var dying_timer : Timer
var player_sprite : Sprite2D
var dying_sprite : Sprite2D


func _ready():
	position = Vector2(512, 450)
	update_animation_params_player(starting_direction)
	animation_player = $AnimationPlayer
	dying_timer = $DyingTimer
	player_sprite = $"Player Sprite"
	dying_sprite = $"Dying Sprite"
	player_sprite.visible = true
	dying_sprite.visible = false 
func  _physics_process(_delta):
	if player_health <= 0:
		state_machine.travel("End")
		player_sprite.visible = false
		dying_sprite.visible = true
		animation_player.play("player_die")
		dying_timer.start(3)
		if can_quit:
			get_tree().change_scene_to_file("res://Levels/game_over.tscn")
		else:
			animation_player.play("player_die")
	update_health()
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	update_animation_params_player(input_direction)
	velocity = input_direction * move_speed
	
	move_and_slide()
	pick_new_state()
	

func update_animation_params_player(move_input : Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)
		animation_tree.set("parameters/Attack/blend_position", move_input)
		animation_tree.set("parameters/Hurt/blend_position", move_input)

func pick_new_state():
	player_is_attacking = false
	if(velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
	if Input.is_key_pressed(KEY_SPACE):
		state_machine.travel("Attack")
		emit_signal("Player_Is_Attacking")
		player_is_attacking = true
		
		
func check_detection_pos(): #Quadrants go left to right top down
	var firstQuad = true #Player is not in the quadrants
	var secondQuad = true
	var thirdQuad = true
	var fourthQuad = true
	
	if position.y <= 344 and position.y >= 59 and position.x > 368:
		firstQuad = false
	elif position.y <= 344 and position.y >= 59 and position.x < 938:
		secondQuad = false
	elif position.y >= 344 and position.y <= 629 and position.x > 368:
		thirdQuad = false
	elif position.y >= 344 and position.y <= 629 and position.x < 938:
		fourthQuad = false
	else:
		return true


func _on_bb_enemy_enemy_attacking():
	player_health -= 30
	





	

func update_health():
	var health_bar = $PlayerHealthBar
	health_bar.value = player_health
	
	if player_health >= 100:
		health_bar.visible = false
	else:
		health_bar.visible = true


func _on_animation_player_animation_finished(anim_name):
	can_quit = true


func _on_dying_timer_timeout():
	can_quit = true


