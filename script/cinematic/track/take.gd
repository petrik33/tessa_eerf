class_name CinematicTakeTrack extends CinematicTrackBase


var director: CinematicDirectorBase
var speed_scale: float
var action: teVisualActionBase
var take: CinematicTake


func _play():
	take = director.direct_take(action, speed_scale)
	if take.is_cut:
		_finish()
	else:
		take.cut.connect(_finish, CONNECT_ONE_SHOT)


func _cancel():
	take.cut.disconnect(_finish)
	take.abort()
