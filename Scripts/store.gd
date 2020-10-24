extends Panel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Money = 5
var StoreCount = 0
var Diamonds = 0 

var StoreCost = 5
var StoreProfit = 2


# Called when the node enters the scene tree for the first time.
func _ready():
	_updateUIMoney()
	

func _updateUIMoney():
	$StoreCountLabel.text = str(StoreCount)
	$MoneyLabel.text = "$ " + str(Money) 
	
func _on_AddMoneyBtn_pressed():
	$StoreTimer.start()
	$ProgressTimer.start()

func InLineTimer(timer):
	yield(get_tree().create_timer(timer), "timeout")


func _on_StoreBuyBtn_pressed():
	if StoreCost <= Money:
		StoreCount += 1 
		Money -= StoreCost
		_updateUIMoney()
	else:
		$PopUpMessageBox.popup()
		InLineTimer(1.5)
		$PopUpMessageBox.hide()
	

func _on_StoreTimer_timeout():
	$StoreTimer.stop()
	$ProgressTimer.stop()
	$ProgressBar.set("value", 0)
	Money += StoreProfit * StoreCount # TODO: Ändern
	_updateUIMoney()


func _on_ProgressTrimer_timeout():
	var current_progress = ($StoreTimer.wait_time - $StoreTimer.time_left) / $StoreTimer.wait_time
	$ProgressBar.set("value", current_progress) 
