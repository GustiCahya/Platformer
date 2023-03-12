extends KinematicBody2D

onready var AnimationPlayer = $AnimationPlayer

const motion = Vector2(0, 0)

const WORLD_LIMIT = 3000
const SPEED = 450
const JUMP_SPEED = 1500
const UP = Vector2(0, -1)
const GRAVITY = 150

var lives = 3;
var score = 0;

func _ready():
	add_to_group("Player")
	update_info_hud()

func _physics_process(delta):
	apply_gravity()
	animate()
	jump()
	move()
	move_and_slide(motion, UP)

func hurt():
	lives -= 1
	run_animate("Hurt")
	update_info_hud()
	if lives < 0:
		get_tree().quit()

func add_score():
	score += 1
	update_info_hud()

func apply_gravity():
	if position.y > WORLD_LIMIT:
		get_tree().quit()
	elif is_on_floor() and motion.y > 0:
		motion.y = 0
	elif is_on_ceiling():
		motion.y = 1
	else:
		motion.y += GRAVITY
		
func jump():
	if Input.is_action_pressed("ui_up") and is_on_floor():
		motion.y = -JUMP_SPEED

func move():
	if Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		motion.x = -SPEED
	elif Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
		motion.x = SPEED
	else:
		motion.x = 0

func run_animate(animation_name):
#	declare variables
	var IdleSprite = $Idle
	var RunSprite = $Run
	var JumpSprite = $Jump
	var FallSprite = $Fall
	var HurtSprite = $Hurt
#	hide all sprites
	IdleSprite.hide()
	RunSprite.hide()
	JumpSprite.hide()
	FallSprite.hide()
	HurtSprite.hide()
#	show animation
	match animation_name:
		"Run":
			RunSprite.flip_h = false
			AnimationPlayer.play("Run")
			RunSprite.show()		
		"ReverseRun":
			RunSprite.flip_h = true
			AnimationPlayer.play("Run")
			RunSprite.show()		
		"Jump":
			AnimationPlayer.play("Jump")
			JumpSprite.show()
		"Fall":
			AnimationPlayer.play("Fall")
			FallSprite.show()
		"Idle":
			AnimationPlayer.play("Idle")
			IdleSprite.show()
		"Hurt":
			AnimationPlayer.play("Hurt")
			HurtSprite.show()
			
func animate():
#	// exception
	if AnimationPlayer.current_animation == "Hurt":
		return
#	// main animate
	if motion.x > 0:
		run_animate("Run")
	elif motion.x < 0:
		run_animate("ReverseRun")
	elif motion.y < 0 and not is_on_ceiling():
		run_animate("Jump")
	elif motion.y > 0 and not is_on_floor():
		run_animate("Fall")
	else:
		run_animate("Idle")

#   HUD
func update_info_hud():
	get_tree().call_group("HUD", "update_info", lives, score)
