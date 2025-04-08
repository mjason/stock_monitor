class RootController < ApplicationController
  def index
    @positions = StockPosition.all
  end
end
