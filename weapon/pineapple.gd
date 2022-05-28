extends Area2D

var screen_size = Vector2(
	ProjectSettings.get("display/window/size/width"),
	ProjectSettings.get("display/window/size/height"))
onready var wall_L = get_node("/root/world/wall_L").get_position()
onready var wall_R = get_node("/root/world/wall_R").get_position()
onready var wall_T = get_node("/root/world/wall_T").get_position()
onready var wall_B = get_node("/root/world/wall_B").get_position()
var from_player
var speed = 10000
export var dir = Vector2.ZERO
var score = 1

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	position += speed * dir * delta
	#print(position.x," ",  20," ",screen_size.x-20)
	if position.x < wall_L.x or position.x > wall_R.x or position.y < wall_T.y or position.y > wall_B.y:
		queue_free()
	

func _on_pineapple_body_entered(body):
	#print("body:%s by_who:%s " % [body.name ,from_player])
	#To avoid collided self body
	if body.name != str(from_player) :
		#print("body:%s by_who:%s " % [body.name ,from_player])
		if body.has_method("damage"):
			#body.rpc("damage",from_player)
			body.callv("damage",[from_player])
		$".".disconnect("body_entered", $".", "_on_pineapple_body_entered")
		$Particles2D.emitting = true
		$Sprite.hide()
		yield(get_tree().create_timer(0.5),"timeout")
		var player=get_node("/root/world/players/"+str(from_player))
#		player.rpc("update_score",from_player,score)
		queue_free()
		
