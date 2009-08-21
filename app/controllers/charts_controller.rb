class ChartsController < ApplicationController
  unloadable
  
  def show
    @data = BacklogChartData.fetch :backlog_id => params[:backlog_id]
    
    if @data.nil?
      render :text => "<span>No chart data.</span>"
    elsif params[:src]=="gchart"
      render :partial => "gchart"
    else
      render :text => "You must supply src", :status => 400
    end
  end
  
end