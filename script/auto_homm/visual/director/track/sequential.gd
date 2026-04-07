class_name teVisualDirectorSequentialTrack extends teVisualDirectorTrackBase


var action: teVisualActionSubSequence
var director: teVisualDirector


func play():
	for sub_action in action.actions:
		await director.play_action(sub_action)
	_finish()
