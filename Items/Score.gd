extends Area2D


func _on_Score_body_entered(body):
	get_tree().call_group("Player", "add_score")
	queue_free()
