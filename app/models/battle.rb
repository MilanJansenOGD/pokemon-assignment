class Battle < ApplicationRecord
  include AASM

  belongs_to :trainer

  has_one :opponent, class_name: "Pokemon", foreign_key: "id", primary_key: "opponent_id"

  enum battle_type: {
    pve: "pve",
    pvp: "pvp"
  }

  aasm(:battle, column: :state, enum: true, whiny_transitions: false) do
    state :start, initial: true
    state :move_selection
    state :escaped
    state :captured
    state :victory
    state :defeat

    event :escape do 
      transitions from: [:start], to: :escaped, guards: :escaping?
    end
    
    event :capture do
      transitions from: [:start, :move_selection], to: :captured, guards: :capturing?
      transitions from: [:start, :move_selection], to: :escaped, guards: :fleeing?
    end
  end

  ESCAPE_CHANCE = 0.5
  CAPTURE_CHANCE= 0.5
  FLEE_CHANCE = 0.3

  def escaping?
    rand <= ESCAPE_CHANCE
  end

  def capturing?
    rand <= CAPTURE_CHANCE
  end

  def fleeing?
    rand <= FLEE_CHANCE
  end
end
