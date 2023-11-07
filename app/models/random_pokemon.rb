class RandomPokemon
  class << self
    def retrieve(highest_level)
      sample_base_pokemon = BasePokemon.all.sample
      level = [1, rand((highest_level-3)...(highest_level+3))].max

      return if sample_base_pokemon.nil?

      sample_base_pokemon.pokemons.create(
        trainer: nil,
        level: level,
        hp: sample_base_pokemon.hp * level,
        attack: sample_base_pokemon.attack * level,
        special_attack: sample_base_pokemon.special_attack * level,
        defense: sample_base_pokemon.defense * level,
        special_defense: sample_base_pokemon.special_defense * level,
        speed: sample_base_pokemon.speed * level,
        current_hp: sample_base_pokemon.hp * level,
        current_attack: sample_base_pokemon.attack * level,
        current_special_attack: sample_base_pokemon.special_attack * level,
        current_defense: sample_base_pokemon.defense * level,
        current_special_defense: sample_base_pokemon.special_defense * level,
        current_speed: sample_base_pokemon.speed * level,
        current_experience: 0,
        experience_to_level: 100*level
      )
    end
  end
end