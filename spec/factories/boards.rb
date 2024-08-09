# frozen_string_literal: true

FactoryBot.define do
  factory :board do
    attempts_count { 1 }

    trait :three_by_three do
      after(:create) do |board|
        generation = create(:generation, board:)

        (0..2).each do |y|
          (0..2).each do |x|
            alive = [true, false].sample
            create(:cell, generation:, x:, y:, alive:)
          end
        end
      end
    end
  end
end
