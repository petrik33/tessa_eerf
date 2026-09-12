class_name CinematicProductionLog extends Node


@export var combat: teCombat
@export var producer: CinematicPlayback
@export var scheduler: CinematicScheduler
@export var take_log: CinematicTakeLog


func _ready() -> void:
	combat.started.connect(_on_combat_started)
	scheduler.track_started.connect(_on_track_started)
	scheduler.track_finished.connect(_on_track_finished)
	producer.filming_started.connect(_on_filming_started)
	producer.filming_finished.connect(_on_filming_finished)
	producer.sequence_started.connect(_on_sequence_started)
	producer.sequence_finished.connect(_on_sequence_finished)


var _filming_start_time: int
var _track_tree_level: int
var _sequence_counter: int


func _on_combat_started(initial_state: teCombatState):
	take_log.initialize(initial_state)


func _on_filming_started():
	_filming_start_time = Time.get_ticks_msec()
	_sequence_counter = 0
	_track_tree_level = 0

	_log("FILMING STARTED")


func _on_filming_finished():
	_log("FILMING FINISHED")


func _on_sequence_started(
	sequence: CinematicSequence,
	speed_scale: float,
	initial_estimated_time_sec: float
):
	_sequence_counter += 1

	_log(
		"SEQUENCE #%d STARTED estimated=%.2fs timeout=%.2fs speed=%.2f"
		% [
			_sequence_counter,
			initial_estimated_time_sec,
			sequence.timeout_sec,
			speed_scale
		]
	)


func _on_sequence_finished():
	_log("SEQUENCE #%d FINISHED" % _sequence_counter)


func _on_track_started(track: CinematicTrackBase, id: int):
	if track is CinematicTakeTrack:

	_log(
		"%sTRACK #%d START - %s"
		% [
			_indent(),
			id,
			_track_name(track),
		]
	)
	_track_tree_level += 1


func _on_track_finished(track: CinematicTrackBase, id: int):
	if track is CinematicTakeTrack:
			% [
				_indent(),
				id
			]
		)
		return
	
	_track_tree_level -= 1
	_log(
		"%sTRACK #%d FINISH - %s"
		% [
			_indent(),
			id,
			_track_name(track),
		]
	)


func _log_take(track: CinematicTakeTrack, id: int):
	var description := take_log.describe(track.action)

	_log(
		"%sTAKE #%d %s"
		% [
			_indent(),
			id,
			description
		]
	)


func _track_name(track: CinematicTrackBase) -> String:
	if track is CinematicTakeTrack:
		return "Take"

	if track is CinematicParallelTrack:
		return "Parallel"

	if track is CinematicSubSequenceTrack:
		return "SubSequence"

	return track.get_class()


func _log(message: String):
	print("%s %s" % [_timestamp(), message])


func _indent() -> String:
	return "  ".repeat(_track_tree_level)


func _timestamp() -> String:
	var elapsed = (
		Time.get_ticks_msec() - _filming_start_time
	) / 1000.0

	return "[%6.2fs]" % elapsed
