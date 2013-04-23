Game = require "../../../lib/hearts/engine/game"
Player = require "../../../lib/hearts/player"
should = require("should")

describe "Game", ->
  beforeEach ->
    @player1 = new Player()
    @player2 = new Player()
    @player3 = new Player()
    @player4 = new Player()
    @game = new Game(@player1, @player2, @player3, @player4)

  it "has an id", ->
    @game.should.have.property('id')

  it "has players", ->
    @game.players.length.should.equal(4)

  describe "#getPlayer", ->
    it "returns a player by id", ->
      @game.getPlayer(@player4.id).id.should.equal(@player4.id)

    it "returns nothing if player doesn't exist", ->
      should.not.exist(@game.getPlayer("foo"))

  describe "#scores", ->
    it "returns the scores", ->
      @game.rounds.push({ scores: -> { north: 10, east: 0, south: 15, west: 1 }})
      @game.rounds.push({ scores: -> { north: 0, east: 0, south: 15, west: 11 }})
      @game.rounds.push({ scores: -> { north: 10, east: 0, south: 15, west: 1 }})
      @game.rounds.push({ scores: -> { north: 10, east: 0, south: 15, west: 1 }})

      scores = @game.scores()
      scores.north.should.equal(30)
      scores.east.should.equal(0)
      scores.south.should.equal(60)
      scores.west.should.equal(14)

  describe "#maxPenaltyReached", ->
    it "returns true if 100 is reached by a player", ->
      @game.scores = -> { north: 100, east: 10, south: 20, west: 3 }
      @game.maxPenaltyReached().should.equal(true)

    it "returns true if 100 is reached by multiple players", ->
      @game.scores = -> { north: 100, east: 10, south: 105, west: 3 }
      @game.maxPenaltyReached().should.equal(true)

    it "returns false if 100 is not reached by any player", ->
      @game.scores = -> { north: 99, east: 10, south: 5, west: 3 }
      @game.maxPenaltyReached().should.equal(false)

    describe "configured to end at 40", ->
      beforeEach ->
        @player1 = new Player()
        @player2 = new Player()
        @player3 = new Player()
        @player4 = new Player()
        @game = new Game(@player1, @player2, @player3, @player4, heartsMaxPoints:40)


      it "returns false if not reached", ->
        @game.scores = -> { north: 39, east: 10, south: 0, west: 3 }
        @game.maxPenaltyReached().should.equal(false)

      it "returns true if reached", ->
        @game.scores = -> { north: 40, east: 10, south: 0, west: 3 }
        @game.maxPenaltyReached().should.equal(true)


