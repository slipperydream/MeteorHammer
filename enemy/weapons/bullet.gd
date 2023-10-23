extends Resource

class_name Bullet

@export var bullet_type : BulletConstants.BulletTypes = BulletConstants.BulletTypes.STRAIGHT
@export var bullet_pattern: BulletConstants.BulletPatterns = BulletConstants.BulletPatterns.SINGLE
@export var bullet_shape : PackedScene 
@export var position : Vector2 
@export var speed : int = 30
@export var angle : float = 90
@export var shot_delay : float = 0.0
@export var aimed : bool = false
