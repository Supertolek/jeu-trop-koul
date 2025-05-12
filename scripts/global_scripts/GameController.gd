extends Node



func health_change(player:Player):
	SignalBus.emit_signal("health_change", player)


	
func coin_collected(coin_color:GlobalObjectsMgmt.COIN_COLOR):
	SignalBus.emit_signal("coin_collected", coin_color)

func key_collected(key_color: GlobalObjectsMgmt.KEY_COLOR):
	SignalBus.emit_signal("key_collected",key_color)
	
func star_collected(star_color: GlobalObjectsMgmt.STAR_COLOR):
	SignalBus.emit_signal("star_collected",star_color)
