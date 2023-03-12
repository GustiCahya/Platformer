extends CanvasLayer

func update_info(lives, score):
	if lives >= 0:
		$VBoxContainer/HBoxContainer/LabelLives.text = str(lives)
	$VBoxContainer/HBoxContainer2/LabelScore.text = str(score)
