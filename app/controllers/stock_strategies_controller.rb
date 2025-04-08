class StockStrategiesController < ApplicationController
  add_breadcrumb "主页", :root_path
  add_breadcrumb "策略", :stock_strategies_path

  before_action :set_stock_strategy, only: [:show, :edit, :update, :destroy]

  def index
    @stock_strategies = Current.user.stock_strategies
  end

  def show
    add_breadcrumb "#{@stock_strategy.name}", stock_strategy_path(@stock_strategy)
  end

  def edit
  end

  def update
    if @stock_strategy.update(stock_strategy_params)
      redirect_to @stock_strategy, notice: "股票策略更新成功"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def new
    @stock_strategy = Current.user.stock_strategies.new
  end

  def create
    @stock_strategy = Current.user.stock_strategies.new(stock_strategy_params)

    if @stock_strategy.save
      redirect_to @stock_strategy, notice: "股票策略创建成功"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @stock_strategy.destroy!

    redirect_to stock_strategies_path, notice: "股票策略删除成功", status: :see_other
  end

  private
  def stock_strategy_params
    params.expect(stock_strategy: [ :name, :stock_symbol, :security_type, :code, :active, :stock_position_id ])
  end

  def set_stock_strategy
    @stock_strategy = Current.user.stock_strategies.find(params[:id])
  end
end
