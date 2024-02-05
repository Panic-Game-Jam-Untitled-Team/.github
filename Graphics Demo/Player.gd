extends CharacterBody3D

@onready var neck = $Neck #Accesses the neck of the player
@onready var camera = $Neck/Camera3D #This acts as the players eyes
@export var cam_sens = 0.004 #How fast the camera turns
var current_speed = 0.0 #The players current speed
var tween : Tween #This makes a tween so that we can have smooth transitions for certain actions
const running_speed = 7.0 #Run speed
const walking_speed = 4.0 #The player's walking speed
const JUMP_VELOCITY = 4.5 #How high the player can jump

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") #This is a value Godot uses to emulate gravity and can be changed

func _ready():
	current_speed = walking_speed #Makes sure that when the game starts the player is at walking pace

func _physics_process(delta):
	tween = create_tween()
	if not is_on_floor(): #This is the gravity function. Without it the player would float
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor(): #Jump function, which makes the player jump
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("left", "right", "forward", "backward") #These nect two are complicated (kinda) basically it moves the character based on where they are looking
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	if Input.is_action_pressed("shift"): #This is simple for now, but when we get a ui we can make a stamina bar
		current_speed = running_speed
		tween.tween_property(camera, "fov", 90, 0.5) #Changes fov to give the illusion of speed
	else:
		current_speed = walking_speed
		tween.tween_property(camera, "fov", 75, 1) #sets fov to normal
#Also note that this would be need to be changed a bit if we wamt a crouch (which we most likely would have)
	move_and_slide()

func _unhandled_input(event): #This function takes the mouse movement and turns it into camera rotation (can easily be made into an inventory system too)
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * cam_sens)
			camera.rotate_x(-event.relative.y * cam_sens)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
