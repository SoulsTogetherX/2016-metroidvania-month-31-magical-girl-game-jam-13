class_name Constants


const DEBUG_FONT_WIDTH := 120


enum LAYERS {
	NONE = 0,
	CAMERA = 1 << 0,
	GROUND = 1 << 1,
	PLAYER = 1 << 2,
	ENEMY  = 1 << 3
}

enum FACTION {
	NONE,
	PLAYER,
	ENEMY,
	NEUTRAL
}
