extends Control

var prs: Array[float]
var barWidth: int = 1000
var barHover: int = -1
const tw: int = 506
const th: int = 300

func _draw() -> void:
    if prs.is_empty():
        return

    for i: int in range(11):
        var y: float = i * th / 10
        draw_line(Vector2(0, y), Vector2(tw, y), Color.DIM_GRAY)

    for i: int in range(prs.size()):
        var barHeight: float = prs[i] * th / 100
        draw_rect(Rect2(i * barWidth, th - barHeight, barWidth, barHeight), Color.CORNFLOWER_BLUE)

    if barHover != -1:
        var barHeight: float = prs[barHover] * th / 100
        draw_rect(Rect2(barHover * barWidth, th - barHeight, barWidth, barHeight), Color.DARK_SLATE_GRAY, false, 2)
        draw_string(get_theme_default_font(), Vector2(10, 20), "%d => %01.3f%%" % [barHover, prs[barHover]], 0, -1, 16, Color.AQUA)

func update_chart(_prs: Array[float]) -> void:
    prs = _prs
    barWidth = int(tw / prs.size())
    barHover = -1
    queue_redraw()

func _input(e: InputEvent) -> void:
    if !is_instance_of(e, InputEventMouseMotion):
        return
    var mm: InputEventMouseMotion = e as InputEventMouseMotion
    if mm.position.x < global_position.x or mm.position.y < global_position.y or mm.position.x > tw + global_position.x or mm.position.y > th + global_position.y:
        return
    barHover = min(prs.size() - 1, int((mm.position.x - global_position.x) / barWidth))
    queue_redraw()
