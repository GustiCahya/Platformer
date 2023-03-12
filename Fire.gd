extends Sprite


func _on_Area2D_body_entered(body):
	get_tree().call_group("Player", "hurt")
