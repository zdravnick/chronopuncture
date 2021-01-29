class TrigramsController < ApplicationController

  def show
    @trigram = Trigram.find(id: id)
  end


end