class GamesController < ApplicationController
  # GET /games
  # GET /games.xml
  
  
  def join
    @game = Game.find params[:id]
  end
  
  def join_game
    @game = Game.find params[:id]
    @runner = Runner.find_or_create_by_mobile_number params[:runner][:mobile_number]
    # @runner.game = @game
    @runner.assign_to_smallest_team(@game)
    respond_to do |format|
    
    # assign runner to smallest team
    if @runner.save
        format.html { redirect_to(capture_path, :notice => "Game was successfully joined. You are on team #{@runner.team}") }
      else
        format.html { render :action => "join" }
      end
    end
    # TODO send confirmation
  end
  
  def balance_games
    # get the total of each team
    # remove a Runner from the team with the most Runners
    # add that Runner to the team with fewer Runners
    # repeat until the teams are even or only one player apart
    # send alert to affected Runners
  end
  
  def end_game
    # set game to inactive
    # determine winner
    # send out end messages
  end
  
  def abort_game
    # set game to inactive
    # send out abort messages
  end
  
  def index
    @games = Game.order("created_at DESC").all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @games }
    end
  end

  # GET /games/1
  # GET /games/1.xml
  def show
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game }
    end
  end

  # GET /games/new
  # GET /games/new.xml
  def new
    @game = Game.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @game }
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
  end

  # POST /games
  # POST /games.xml
  def create
    @game = Game.new(params[:game])
    
    respond_to do |format|
      if @game.save
        format.html { redirect_to(@game, :notice => 'Game was successfully created.') }
        format.xml  { render :xml => @game, :status => :created, :location => @game }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.xml
  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to(@game, :notice => 'Game was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.xml
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to(games_url) }
      format.xml  { head :ok }
    end
  end
end
