class BattlesController < ApplicationController
  def index
    @battles = Battle.all
  end

  def new
    @trainer = Trainer.find_or_create_by(name: "Ash Ketchum")
    @opponent = Pokemon.find_by(id: params[:opponent_id])

    @battle = Battle.new(
      battle_type: params.fetch(:battle_type, "encounter"),
      opponent: @opponent,
      trainer: @trainer
    )
  end

  def create
    @battle = Battle.new(battle_params)

    if @battle.save
      redirect_to battle_path(@battle)
    else
      redirect_to new_battle_path(battle_params)
    end
  end

  def show
    @battle = Battle.find(params[:id])
  end

  def escape_battle
    @battle = Battle.find(params[:id])
    if rand <= Battle::ESCAPE_CHANCE then
      @battle.update(state: :escaped)
    else
      @battle.update(state: :move_selection)
    end
    redirect_to battle_path(@battle)
  end

  def capture
    @battle = Battle.find(params[:id])
    if rand <= Battle::CAPTURE_CHANCE then
      @battle.update(state: :captured)
      @battle.trainer.pokemons << @battle.opponent
    else
      if rand <= Battle::FLEE_CHANCE then
        @battle.update(state: :escaped)
      else 
        @battle.update(state: :move_selection)
      end
    end
    redirect_to battle_path(@battle)
  end

  def attack
    @battle = Battle.find(params[:id])
    opponent = @battle.opponent
    pokemon = @battle.trainer.pokemons.first

    moves = []

    if pokemon.current_speed >= opponent.current_speed then
      moves.push [opponent, pokemon.current_attack]
      moves.push [pokemon, opponent.current_attack]
    else
      moves.push [pokemon, opponent.current_attack]
      moves.push [opponent, pokemon.current_attack]
    end

    moves.each do |move|
      move[0].update(current_hp: move[0].current_hp - move[1])
      if move[0].current_hp <= 0 then 
        if move[0] == pokemon then
          @battle.update(state: :defeat)
        else
          @battle.update(state: :victory)
        end
          redirect_to battle_path(@battle) and return
      end
    end

    @battle.update(state: :move_selection)
    redirect_to battle_path(@battle)
  end

  private

  def battle_params
    params.
      require(:battle).
      permit(
        :battle_type,
        :opponent_id,
        :trainer_id
      )
  end
end