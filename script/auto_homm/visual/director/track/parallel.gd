class_name teVisualDirectorParallelTrack extends teVisualDirectorTrackBase


var action: teVisualActionParallel
var director: teVisualDirector
var playing: int
var speed_scale: float


func play():
	director.played.connect(_on_sub_action_played)
	playing = action.actions.size()
	if playing == 0:
		_finish()
	for sub_action in action.actions:
		director.play_action(sub_action, speed_scale)


func _on_sub_action_played(sub_action: teVisualActionBase):
	if not action.actions.has(sub_action):
		return
	playing -= 1
	if playing == 0:
		director.played.disconnect(_on_sub_action_played)
		_finish()
