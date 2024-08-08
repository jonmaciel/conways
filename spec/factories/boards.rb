# frozen_string_literal: true

FactoryBot.define do
  factory :board do
    name { 'MyString' }
    attempts_count { 1 }
  end
end
