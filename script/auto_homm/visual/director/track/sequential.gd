class_name teVisualDirectorSequentialTrack extends teVisualDirectorTrackBase


var action: teVisualActionSubSequence
var director: teVisualDirector
var speed_scale: float


func play():
	for sub_action in action.actions:
		await director.play_action(sub_action, speed_scale)
	_finish()
