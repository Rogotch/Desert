extends Node

var Effects = []

func _ready():
	Effects = loadDB("res://Resources/DataBase/Effects.json")
	pass

func loadDB(path):
	var uploadedData = {}
	var data_file = File.new()
	
	if data_file.open(path, File.READ) != OK:
		print("Error open file")
		return
		
	var data_text = data_file.get_as_text()
	data_file.close()
	var data_parse = JSON.parse(data_text)
	
	if data_parse.error != OK:
		print("Error parse")
		return
		
	var data = data_parse.result
	uploadedData = data
	
	return uploadedData
	pass

func GetObjFromArrByID(arr, id):
	for obj in arr:
		if obj.id == id:
			return obj
	pass
