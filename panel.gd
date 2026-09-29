extends Control

@onready var onePtCtrl: SpinBox = %OnePt
@onready var twoPtCtrl: SpinBox = %TwoPt
@onready var threePtCtrl: SpinBox = %ThreePt
@onready var negPtCtrl: SpinBox = %NegPt
@onready var ltdCtrl: SpinBox = %LTD
@onready var gfiCtrl: SpinBox = %GFI
@onready var deckSizeCtrl: SpinBox = %DeckSize
@onready var winAtCtrl: SpinBox = %WinAt
@onready var calcButton: Button = %Calc
@onready var chartCtrl: Control = %Chart

func _ready() -> void:
    onePtCtrl.value_changed.connect(points_changed)
    twoPtCtrl.value_changed.connect(points_changed)
    threePtCtrl.value_changed.connect(points_changed)

    twoPtCtrl.value_changed.connect(func(new_value: float) -> void:
        ltdCtrl.max_value = min(3, new_value)
    )

    threePtCtrl.value_changed.connect(func(new_value: float) -> void:
        gfiCtrl.max_value = min(3, new_value)
    )

    calcButton.pressed.connect(calculate)


func points_changed(_ignore: float) -> void:
    var pos: int = int(deckSizeCtrl.value) % 5
    var maxVal: int = max(4, int(onePtCtrl.value + twoPtCtrl.value * 2 + threePtCtrl.value * 3) / 2 * 5 - 1);
    var minVal: int = maxVal - 4
    deckSizeCtrl.min_value = minVal
    deckSizeCtrl.max_value = maxVal
    deckSizeCtrl.value = maxVal + pos

func calculate() -> void:
    var winAt: int = int(winAtCtrl.value)
    var initialDeck: State = State.new([
        onePtCtrl.value + ltdCtrl.value,
        twoPtCtrl.value - ltdCtrl.value + gfiCtrl.value,
        threePtCtrl.value - gfiCtrl.value,
        negPtCtrl.value,
        deckSizeCtrl.value - onePtCtrl.value - twoPtCtrl.value - threePtCtrl.value - negPtCtrl.value
    ], 0)
    initialDeck.pr = 1
    var deckSize: int = initialDeck.deckSize
    var states: Dictionary = {initialDeck.key: initialDeck}
    var frontier: Array[String] = [initialDeck.key]
    while !frontier.is_empty():
        var newFrontier: Array[String] = []
        for key in frontier:
            var parent: State = states[key]
            # For each draw type
            for i: int in range(parent.deck.size()):
                # Skip exhausted draw types
                if parent.deck[i] == 0:
                    continue

                # Draw card and build new deck/state
                var newDeck: PackedInt32Array = parent.deck.duplicate()
                newDeck[i] -= 1
                var newState: State = State.new(newDeck, parent.pts)
                if !states.has(newState.key):
                    # Save new state, accumulate points
                    states[newState.key] = newState
                    if i <= 2:
                        newState.pts += i + 1
                    elif i == 3:
                        newState.pts -= 1
                    if newState.pts < winAt:
                        newFrontier.append(newState.key)
                else:
                    newState = states[newState.key]
                # Add probability of draw happening
                newState.pr += parent.pr * parent.deck[i] / parent.deckSize
        deckSize -= 1
        frontier = newFrontier

    var games: Array[float] = []
    games.resize(initialDeck.deckSize + 1)
    var wins: Array[float] = []
    wins.resize(initialDeck.deckSize + 1)
    for s: State in states.values():
        var cardsAccessed = initialDeck.deckSize - s.deckSize
        games[cardsAccessed] += s.pr
        if s.pts >= winAt:
            wins[cardsAccessed] += s.pr

    var prs: Array[float] = []
    prs.resize(wins.size())
    for i: int in range(wins.size()):
        # Wins + chance of winning previously
        prs[i] = (wins[i] + (1 - games[i])) * 100
        print("%d %1.3f" % [i, prs[i]])
    chartCtrl.update_chart(prs)
    print("%d states processed" % [states.size()])
