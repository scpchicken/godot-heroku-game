extends KinematicBody2D

var ACCELERATION = 500
var MAX_SPEED = 500
const FRICTION = 450
var velocity = Vector2.ZERO
var win_show = false

signal restart

#onready var animationPlayer = $Anim
onready var animTr = $AnimTr
onready var animState = animTr.get("parameters/playback")
enum ACT {IDLE, MOVE, ATTACT, STUNNED, HURT, BRUH}
export(ACT) var state = ACT.MOVE
puppet var puppet_state
puppet var puppet_input_vector = Vector2.ZERO
puppet var puppet_pos =  Vector2()
var prev_bombing = false
var  prev_attacking = false
var input_vector = Vector2.ZERO
onready var player_id = get_tree().get_network_unique_id()

func _ready():
	self.connect("restart", get_node("/root/lobby"), "restart_game")

	$AnimTr.active = true
	
remotesync func attack(pos, att_dir, by_who):
	var weapon = load("res://weapon/pineapple.tscn").instance()
	get_node("/root/world").add_child(weapon)
	weapon.position = pos
	print(att_dir)
#	if att_dir != null:
	weapon.dir = att_dir
#	else:
#		weapon.dir = Vector2(1, 0)
	weapon.from_player = by_who
	
func _process(delta):
	if is_network_master():
		get_input()
		rset("puppet_state",state)
	else:
		state = puppet_state
		
	match state:
			ACT.MOVE:
				move_state(delta)
			ACT.ATTACT:
				pass
#				attack_state(delta)
			ACT.HURT:
				pass
#				hurt_state(delta)
			ACT.STUNNED:
				state = ACT.BRUH
				bruh()
			ACT.BRUH:
				stunned_state()
			ACT.IDLE:
				pass



func get_input():
	if state == ACT.STUNNED:
		return
		
	var attacking = Input.is_action_pressed("ui_attack")
	if attacking and not prev_attacking:
		$attack_timer.start()
		prev_attacking = attacking
		#prev_motion equal direction
		var pos = global_position
		var mouse_pos = get_viewport().get_mouse_position()
		var direc = Vector2(mouse_pos.x - pos.x, mouse_pos.y - pos.y).normalized() / 5
		rpc("attack", pos, direc, get_tree().get_network_unique_id())
	

		
	input_vector.x = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	rset("puppet_input_vector",input_vector)
	rset("puppet_pos",position)
	
func move_state(delta):
	if !is_network_master():
		input_vector = puppet_input_vector
		position = puppet_pos

	if input_vector != Vector2.ZERO :
		velocity = velocity.move_toward(input_vector * MAX_SPEED , ACCELERATION * delta)
	else:
		animState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)

remotesync func restart_game():
#	print("ok boomer")
	emit_signal("restart", int(self.name))

puppet func winguy():
	print("winner winer chicken dijnner")
	get_node("/root/world/winlabel").text = "you win"
	get_node("/root/world/winlabel").show()
	rpc("restart_game")
puppet func shrink():
	print("ha ya shrink")
	get_node("/root/world/winlabel").text = "you lose"
	get_node("/root/world/winlabel").show()
	rpc("restart_game")

func stunned_state():
	animState.travel("Stunned")
	

func bruh():
	rpc("shrink")
	rpc("winguy")
	
puppet func stun():
	state = ACT.STUNNED
	
func setPlayerName(newName):
	$plName.text = newName
	
func damage(by_who):
	if state ==  ACT.STUNNED:
		return
	rpc("stun")
	stun()

func _on_attack_timer_timeout():
	prev_attacking = false
