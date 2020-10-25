extends Node

export var Money = 5

var store_scene = preload("res://Scenes/store.tscn")

#signals
signal STORE_PURCHASED
signal MANAGER_UNLOCKED
signal SHOW_WARNING

func _ready():
	LoadGameData()
	SetupSignalListeners() 
	_updateUI()


func AddMoney(amt):
	Money += amt
	_updateUI()
	
func _updateUI():
	$MoneyLabel.text = "$ " + str(Money) 	
	
func OnStoreMakeMoney(amt):
	AddMoney(amt)	

func OnUnlockManager(_self, amt):
	if amt <= Money:
		Money -= amt
		_updateUI()
		emit_signal("MANAGER_UNLOCKED", _self)
	else:
		emit_signal("SHOW_WARNING", "You don't have enough money to unlock the manager for this store")
		
		
func OnBuyStore(_self, amt):
	if amt <= Money:
		Money -= amt	
		_updateUI()
		emit_signal("STORE_PURCHASED", _self)
	else:
		emit_signal("SHOW_WARNING", "You don't have enough money to buy this store. You need: $ %s " % amt)

	
func SetupSignalListeners():
	for store in $GridContainer.get_children():
		store.connect("PRODUCTION_COMPLETE",self,"OnStoreMakeMoney")
		store.connect("ON_BUY_STORE",self,"OnBuyStore")
		store.connect("ON_UNLOCK_MANAGER",self,"OnUnlockManager")

func LoadGameData():
	var mainData = {}
	var file = File.new()
	file.open("res://Assets/GameData/GameData.prn", File.READ)
	while !file.eof_reached():
		var data_set = Array(file.get_csv_line())
		mainData[mainData.size()]  = data_set
	#	print(data_set[1])
		var new_store = store_scene.instance()
		new_store.get_node("StoreLabel").text = data_set[0]
		new_store.StoreCost = int(data_set[1])
		new_store.StoreProfit = int(data_set[2])
		new_store.manager_cost = int(data_set[3])
		#new_store.get_node("AddMoneyBtn").set_button_icon(load("res://Assets/images/" + data_set[4]))
		$GridContainer.add_child(new_store)
	file.close()