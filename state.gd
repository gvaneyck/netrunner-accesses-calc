class_name State extends RefCounted

var key: String
var deck: PackedInt32Array
var deckSize: int
var pts: int
var pr: float

func _init(_deck: Variant, _pts: int) -> void:
    key = "%d,%d,%d,%d,%d" % [_deck[0], _deck[1], _deck[2], _deck[3], _deck[4]]
    deck = PackedInt32Array(_deck)
    deckSize = deck[0] + deck[1] + deck[2] + deck[3] + deck[4]
    pts = _pts
    pr = 0
