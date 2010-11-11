class CapturesController < ApplicationController
  
  def new
    @capture = Capture.new
  end
  
  def create
    # Confirm known Runner, if not Runner create
    runner = Runner.find_by_mobile_number(params[:runner][:mobile_number])
    node = Node.find_by_code(params[:node][:code])
    @capture = Capture.new(params[:capture])
    @capture.node = node
    @capture.runner = runner
    @capture.game = node.game    
    respond_to do |format|
      if @capture.save
        format.html { redirect_to(capture_path, :notice => 'Zown was successfully captured.') }
      else
        format.html { redirect_to(capture_path, :notice => @capture.errors) }
      end
    end
  end
  
end
