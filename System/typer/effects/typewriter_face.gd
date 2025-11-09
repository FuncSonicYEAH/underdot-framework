# FaceEffect.gd
extends RichTextEffect
class_name FaceEffect

var bbcode = "face"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	if not char_fx.env.has("path"):
		return false

	var path = char_fx.env["path"]
	if not ResourceLoader.exists(path):
		push_error("Face image not found: %s" % path)
		return false

	var texture = load(path)
	if not texture or not texture is Texture2D:
		push_error("Invalid face texture: %s" % path)
		return false

	# 设置字符位置为纹理尺寸
	char_fx.absolute_offset.y -= texture.get_height()
	char_fx.rect = Rect2(Vector2.ZERO, texture.get_size())
	char_fx.texture = texture
	char_fx.advance = texture.get_width()

	return true
