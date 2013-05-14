# -*- coding: utf-8 -*-
class Language < ActiveRecord::Base
  attr_accessible :name
  has_many :user_languages
  has_many :users, through: :user_languages

  validates :name,
    presence: { is: true, message: "Namnet måste fyllas i." },
    uniqueness: { is: true, message: "Det finns redan ett språk med det namnet." }

  before_save do
    self.name.downcase!
  end
end