# frozen_string_literal: true

FactoryBot.define do
  factory :cell do
    generation { nil }
    x { 1 }
    y { 1 }
    alive { false }
  end
end
