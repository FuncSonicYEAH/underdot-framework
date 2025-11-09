extends Node

enum OverWorld{
	MOVING, 
	MENU, 
	DIALOG,
	SAVING
}

enum Battle{
	ENEMYTRUN, 
	MENU
}

var OverworldState = OverWorld.MOVING
var BattleState = Battle.MENU
