extends PopupDialog


func _ready():
	var main = get_tree().get_root().get_node("Main")
	main.connect("SHOW_WARNING", self, "PopupDialog")
	
	
func PopupDialog(message):
	$PopUpMessageLabel.text = message
	self.popup()
	$Timer.start()
	

func _on_Timer_timeout():
	self.hide()
