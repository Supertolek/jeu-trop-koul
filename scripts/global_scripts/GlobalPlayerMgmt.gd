extends Node

enum PLAYER_STATE {
	IDLE,
	RUNNING,
	HURT,
	DIE,
	FALLING,
	STANDBY,
	RAISING,
	ATTACK_1,
	ATTACK_2,
	ATTACK_3,
	CHARGE_ATTACK,
	CAST_CHARGED_ATTACK,

}
enum PLAYER_DIRECTION {
	UP,
	LEFT,
	DOWN,
	RIGHT,
}

func get_direction_string(direction: PLAYER_DIRECTION) -> String:
	match direction:
		PLAYER_DIRECTION.UP:
			return "up"
		PLAYER_DIRECTION.LEFT:
			return "left"
		PLAYER_DIRECTION.DOWN:
			return "down"
		PLAYER_DIRECTION.RIGHT:
			return "right"
	return ""
