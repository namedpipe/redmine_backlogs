include ItemsHelper

class BacklogsController < ApplicationController
  unloadable
  before_filter :find_backlog, :only => [:show, :update]
  before_filter :find_project, :authorize

  protect_from_forgery :only => []

  def index
    # Default to hide the closed backlogs
    if cookies[:hide_closed_backlogs].nil?
      @hide_closed_backlogs = true
      cookies[:hide_closed_backlogs] = "true"
    else
      @hide_closed_backlogs = (cookies[:hide_closed_backlogs] == "true")
    end
    # Default to hide the closed items
    if cookies[:hide_closed_items].nil?
      @hide_closed_items = true
      cookies[:hide_closed_items] = "true"
    else
      @hide_closed_items = (cookies[:hide_closed_items] == "true")
    end
    @hide_tasks = (cookies[:hide_tasks] == "true")
    @items         = Item.find_by_project(@project, :hide_closed_items => @hide_closed_items)
    @item_template = Item.new
    @backlogs      = Backlog.find_by_project(@project)
  end

  def show
    render :json => @backlog.to_json(:methods => [:description, :end_date, :eta, :name]) 
  end
  
  def update
    @backlog = Backlog.update params
    render :json => @backlog.to_json(:methods => [:description, :end_date, :eta, :name]) 
  end

  private
  
  def find_project
    @project = if !params[:project_id].nil?
                 Project.find(params[:project_id])
               else
                 Backlog.find(params[:id]).version.project
               end
  end
  
  def find_backlog
    @backlog = if params[:id]=='0' || params[:id].nil?
                 nil
               else
                 Backlog.find(params[:id])
               end
  end
end
