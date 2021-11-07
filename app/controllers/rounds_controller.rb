class RoundsController < ApplicationController
  before_action :set_round, only: %i[show edit update destroy update_score]
  skip_before_action :verify_authenticity_token, only: :update_score

  # GET /rounds or /rounds.json
  def index
    @rounds = Round.all
  end

  # GET /rounds/1 or /rounds/1.json
  def show
    @can_edit =
      cookies[:my_rounds].split(',').include?(@round.id.to_s) if cookies[
      :my_rounds
    ].present?

    puts "@can_edit #{@can_edit}"
  end

  # GET /rounds/new
  def new
    @round = Round.new
  end

  # GET /rounds/1/edit
  def edit; end

  # POST /rounds or /rounds.json
  def create
    @round = Round.new(round_params)

    respond_to do |format|
      if @round.save
        if cookies[:my_rounds].nil?
          cookies[:my_rounds] = @round.id
        else
          cookies[:my_rounds] += ",#{@round.id.to_s}"
        end
        format.html do
          redirect_to @round, notice: 'Round was successfully created.'
        end
        format.json { render :show, status: :created, location: @round }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json do
          render json: @round.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def update_score
    data = JSON.parse(request.body.read)
    current_arrow = data['current_arrow']
    score = data['score']
    if current_arrow.present?
      @round.scores[current_arrow] = score
      @round.save

      return render json: { status: 'success' }
    end

    render json: { status: 'error' }
  end

  # PATCH/PUT /rounds/1 or /rounds/1.json
  def update
    respond_to do |format|
      if @round.update(round_params)
        format.html do
          redirect_to @round, notice: 'Round was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @round }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json do
          render json: @round.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /rounds/1 or /rounds/1.json
  def destroy
    @round.destroy
    respond_to do |format|
      format.html do
        redirect_to rounds_url, notice: 'Round was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_round
    @round = Round.find(params[:id])
    @total =
      @round
        .scores
        .filter { |score| score != '-1' }
        .map { |score| score == 'X' ? 10 : score.to_i }
        .sum
  end

  # Only allow a list of trusted parameters through.
  def round_params
    params.require(:round).permit(:name, :score, :current_arrow)
  end
end
