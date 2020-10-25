extends Panel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var StoreCount = 0
#var Diamonds = 0 

var StoreCost
var StoreProfit
var manager_cost

var cost_multiplier = 0.2

var manager_unlocked = false


#const Main_Money = preload("res://Scripts/Main.gd").Money
var timer_running = false

# Signal Declaration
signal PRODUCTION_COMPLETE
signal ON_BUY_STORE
signal ON_UNLOCK_MANAGER

# Called when the node enters the scene tree for the first time.
func _ready():
	var main = get_tree().get_root().get_node("Main")
	print(main.name)

	main.connect("STORE_PURCHASED", self, "StorePurchased")
	main.connect("MANAGER_UNLOCKED", self, "UnlockedManager")
	_updateUIMoney()
	

func _updateUIMoney():
	$StoreCountLabel.text = str(StoreCount)
	#$MoneyLabel.text = "$ " + str(Money) 
	
func _on_AddMoneyBtn_pressed():
	
	if !timer_running and StoreCount > 0:
		timer_running = true
		$StoreTimer.start()
		$ProgressTimer.start()
	
func StorePurchased(_store):
	if self == _store:
		StoreCount+=1
		StoreCost += stepify(StoreCost * cost_multiplier, 0.01)
		_updateUIMoney()
	
func UnlockedManager(_store):
	if self == _store:
		manager_unlocked = true
		$UnlockManagerCheckbox.pressed = true
		
func _on_StoreBuyBtn_pressed():

		#StoreCost += StoreCost * cost_multiplier
		emit_signal("ON_BUY_STORE", self, StoreCost)
	
	
	
	
	#if StoreCost <= Money:
	#	StoreCount += 1 		
	#	Money -= StoreCost 		
	#	get_owner().AddMoney(-StoreCost)
	#	StoreCost += StoreCost * cost_multiplier 
	#	_updateUIMoney()
	#else:
	#	NotEnoughMoney()
	

func _on_StoreTimer_timeout():
	timer_running = false
	$StoreTimer.stop()	
	$ProgressBar.set("value", 0)
	emit_signal("PRODUCTION_COMPLETE", StoreCount * StoreProfit)
	#Money += StoreProfit * StoreCount # TODO: Ändern	
	#get_owner().AddMoney(StoreProfit * StoreCount)
	$ProgressTimer.stop()
	if manager_unlocked:
		_on_AddMoneyBtn_pressed()	
	_updateUIMoney()
	
	
	
func _on_ProgressTrimer_timeout():
	var current_progress = ($StoreTimer.wait_time - $StoreTimer.time_left) / $StoreTimer.wait_time
	$ProgressBar.set("value", current_progress) 


func _on_UnlockManagerCheckbox_pressed():
	if !manager_unlocked:
		$UnlockManagerCheckbox.pressed = false
		emit_signal("ON_UNLOCK_MANAGER", self, manager_cost)
	else:
		$UnlockManagerCheckbox.pressed = true