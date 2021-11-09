extends Node

#
#Надо запретить переходить на  угловые клетки, если на соседних есть препятствия
#То есть, на (1, -1) нельзя перейти, если на (1. 0) или (0, -1) есть препятствия
#Можно решить так - if abs(Direction.x) + abs(Direction.y) > 1 и дальше писать пропуск
#
#
#Надо запретить использовать междузонье для перехода в ту же зону, из которой персонаж и вышел
#
#	Надо если конечная точка и финальная точка пути находятся внутри одной зоны, то проводить поиск пути только внутри этой зоны
#	Иначе уже охватывать зону больше, но с условием перехода в следующую зону, а не скачком через междузонье
#	По сути надо проводить поиск пути в несколько этапов:
#	Сначала локальный - ищем путь в своей зоне, а потом глобальный - ищем путь среди всех зон
#	Так в приоритете будет путь без траты очков зоны
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
