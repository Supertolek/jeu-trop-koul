class_name FinishScreen
extends Control

func _ready() -> void:
	size = get_viewport_rect().size
	

func display_winners(winners: Array[Player]):
	if len(winners) == 0:
		%WinnerLabel.text = "Oh shit I think there's a bug..."
	elif len(winners) == 1:
		%WinnerLabel.text = "The winner is player {winner}".format({"winner": Global.players.find(winners[0])+1})
	else:
		%WinnerLabel.text = "The winners are "
		for winner in winners:
			%WinnerLabel.text += "player " + str(Global.players.find(winner)+1)
			if winners.find(winner) < len(winners)-2:
				%WinnerLabel.text += ", "
			elif winners.find(winner) < len(winners)-1:
				%WinnerLabel.text += " and "
		%WinnerLabel.text += "."
	%WinnerLabel.set("theme_override_font_sizes/font_size", 1)
	%WinnerLabel.set("theme_override_font_sizes/font_size", min(%GoodTitle.size.x / %WinnerLabel.size.x, 50))
