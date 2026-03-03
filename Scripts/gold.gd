extends Area2D



func _on_body_entered(body: Node2D) -> void:
	queue_free()
	GlobalManager.col_gold += 1
