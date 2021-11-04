extends Node

#
#
#
#
#
#	Создать скрипт с хранением разных кусков кода
#		Катающаяся плашка при помощи AnimationPlayer:
#	var backStart = $UI/BottomUI/Back.rect_position
#	var backEnd = Vector2( 30 + $UI/BottomUI/Buttons.rect_size.x/10 * (EndScreen*2+1) - 110, $UI/BottomUI/Back.rect_position.y)
#	var backAnim = $UI/BottomUI/Back/AnimationUI.get_animation("BottomUISelect")
#	var backIDX = backAnim.find_track(".:rect_position")
#	backAnim.track_set_key_value(backIDX, 0, backStart)                                                                                                                                                                                                              
#	backAnim.track_set_key_value(backIDX, 1, backEnd)
#	$UI/BottomUI/Back/AnimationUI.play("BottomUISelect")
#	
#
#
#
#
#
#
#
#
#
