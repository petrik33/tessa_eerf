@abstract
class_name teVisualVfxInstanceBase extends Node2D


@abstract func play(params: Dictionary, speed_scale: float)
@abstract func impact_made() -> bool
@abstract func impact_signal() -> Signal
@abstract func finished_signal() -> Signal
@abstract func duration() -> float
