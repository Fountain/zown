class CapturesController < ApplicationController
  
  def index
    @captures = Capture.order("created_at DESC").all
  end
  
  def new
    @capture = Capture.new
    #for test view mockup only
    @teams_size = 3
    @teams = ['red', 'blue', 'yellow']
    @times = ['24', '320', '156']
    @captures = ['5', '9', '6']
    @number_of_zowns = 12
  end
  
  def create
    # Confirm known Runner, if not Runner create
    @capture = Capture.new(params[:capture])
    runner = Runner.find_or_create_by_mobile_number(params[:runner][:mobile_number])
    # check to see if the runner belongs to a game
    if runner.game
      team = runner.current_team
      @capture.team = team
      node = Node.find_by_code(params[:node][:code])
      if node
        @capture.node = node
        @capture.game = node.game if node.game 
      else
        @capture.errors.add :node, 'not found'
      end
      @capture.runner = runner
      
      respond_to do |format|
        if @capture.save
          format.html { redirect_to(capture_path, :notice => 'Zown was successfully captured.') }
        else
          format.html { render :action => :new }
        end
      end
    else
      # tell them to join the game first
      redirect_to(join_game_path(Game.active_game), :notice => 'Please join the game first')
    end 
  end
  
  def destroy
    @capture = Capture.find(params[:id])
    @capture.destroy

    respond_to do |format|
      format.html { redirect_to(captures_url) }
    end
  end
  
end
