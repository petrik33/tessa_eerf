class_name teVisualTracks


func _init() -> void:
	Utils.assert_static_lib()


static func parallel(tracks: Array[teVisualTrackBase]) -> teVisualParallelTrack:
	var track := teVisualParallelTrack.new()
	track.tracks = tracks
	return track


static func sub_sequence(tracks: Array[teVisualTrackBase]) -> teVisualSubSequenceTrack:
	var track := teVisualSubSequenceTrack.new()
	track.tracks = tracks
	return track


static func take(director: teVisualDirectorBase, action: teVisualActionBase, speed_scale: float) -> teVisualTakeTrack:
	var track := teVisualTakeTrack.new()
	track.director = director
	track.action = action
	track.speed_scale = speed_scale
	return track
