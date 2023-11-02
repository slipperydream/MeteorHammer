extends Node

class_name EnemyConstants
const FACING = {
	Vector2(0, -1): 'north',
	Vector2(1, -1): 'northeast',
	Vector2(1, 0): 'east',
	Vector2(1, 1): 'southeast',
	Vector2(0, 1): 'south',
	Vector2(-1, 1): 'southwest',
	Vector2(-1, 0): 'west',
	Vector2(-1, -1): 'northwest',
}

enum Size{
	SMALL = 32,
	MEDIUM = 64,
	LARGE = 128,
	X_LARGE = 256,
}

enum Formations{
	SINGLE,
	CIRCLE,
	WALL,
	BOX,
	LINE,
	X,
	VEE,
	W
}
