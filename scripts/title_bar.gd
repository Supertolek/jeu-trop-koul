@tool
extends Node2D

@export var title_text: String = "Title":
	set(value):
		title_text = value
		if value:
			%TitleLabel.text = value
			%Underline.points = PackedVector2Array([
				Vector2(0, %TitleLabel.size.y-8),
				Vector2(10, %TitleLabel.size.y+2),
				Vector2(%TitleLabel.size.x+20, %TitleLabel.size.y+2),
				Vector2(%TitleLabel.size.x+30, %TitleLabel.size.y-8)
			])
			print(%Underline.points)

func refresh_text():
	%TitleLabel.text = title_text
	%Underline.points = PackedVector2Array([
		Vector2(0, %TitleLabel.size.y-8),
		Vector2(10, %TitleLabel.size.y+2),
		Vector2(%TitleLabel.size.x+10, %TitleLabel.size.y+2),
		Vector2(%TitleLabel.size.x+20, %TitleLabel.size.y-8)
	])
	print(%Underline.points)

@export_tool_button("refresh") var refresh_text_action = refresh_text
