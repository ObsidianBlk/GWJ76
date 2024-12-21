extends ColorRect


# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func set_progress(p : float) -> void:
	p = clampf(p, 0.0, 1.0)
	if material is ShaderMaterial:
		material.set_shader_parameter(&"progress", p)
