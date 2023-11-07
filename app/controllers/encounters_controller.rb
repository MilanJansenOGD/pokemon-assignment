class EncountersController < ApplicationController
  def new
    trainer = Trainer.find_by(name: "Ash Ketchum")
    highest_level = trainer.pokemons.max_by{|k| k[:level]}[:level]
    @wild_pokemon = RandomPokemon.retrieve(highest_level)
  end
end
