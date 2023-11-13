extends CharacterBody2D

@export var move_speed: float = 300
@export var starting_direction: Vector2 = Vector2(0, 0.5)
# parameters/Idle/blend_position
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")


func _ready():
	var screenSize = get_viewport_rect().size
	position = screenSize / 2
	update_animation_params(starting_direction)

func  _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	update_animation_params(input_direction)
	velocity = input_direction * move_speed
	
	move_and_slide()
	pick_new_state()

func update_animation_params(move_input : Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)

func pick_new_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
