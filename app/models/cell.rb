# frozen_string_literal: true

class Cell < ApplicationRecord
  belongs_to :generation

  default_scope { order(:y, :x) }
end
