extends Node

var ShowPanel = false
func _ready():
	pass

func restart_game(id):
	print("at restart gamerrrrrrrrrrr   ", id)
	$CanvasLayer/InfoPanel.show()
	$CanvasLayer/Loading.show()
	get_node("/root/world/winlabel").hide()
#	$
	
	gamestate.gamer()
	


func _on_join_pressed(): 
	var new_player_name = $CanvasLayer/InfoPanel/userName.text
	print("joining the game")
	gamestate.join_game(new_player_name)
	print('joined to game')
