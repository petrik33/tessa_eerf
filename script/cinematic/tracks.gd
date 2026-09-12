class_name CinematicTracks


func _init() -> void:
	Utils.assert_static_lib()


static func parallel(scheduler: CinematicScheduler, tracks: Array[int]) -> CinematicParallelTrack:
	var track := CinematicParallelTrack.new()
	track.scheduler = scheduler
	track.tracks = tracks
	return track


static func sub_sequence(scheduler: CinematicScheduler, tracks: Array[int]) -> CinematicSubSequenceTrack:
	var track := CinematicSubSequenceTrack.new()
	track.scheduler = scheduler
	track.tracks = tracks
	return track


static func take(director: CinematicDirectorBase, action: teVisualActionBase, speed_scale: float) -> CinematicTakeTrack:
	var track := CinematicTakeTrack.new()
	track.director = director
	track.action = action
	track.speed_scale = speed_scale
	return track
