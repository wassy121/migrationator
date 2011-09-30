class ServersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_user

  # GET /servers
  def index
    @servers = @user.servers
  end

  # GET /servers/2
  def show
    @server = Server.find(params[:id])
  end

  # GET /servers/new
  def new
    @server = @user.servers.build
  end

  # GET /servers/2/edit
  def edit
    @server = @user.servers.find(params[:id])
  end

  # POST /servers
  def create
    @server = @user.servers.new(params[:server])
    if @server.save
      flash[:notice] = "Server was successfully created"
      redirect_to server_url(@server)
    else
      render :action => "new"
    end
  end

  # PUT /users/1/servers/2
  def update
    @server = @user.servers.find(params[:id])

    if @server.update_attributes(params[:server])
      flash[:notice] = "Server was successfully updated"
      redirect_to server_url(@server)
    else
      render :action => "edit" 
    end
  end

  # DELETE /servers/1
  def destroy
    @server = @user.servers.find(params[:id])
    @server.destroy

    respond_to do |format|
      format.html { redirect_to(servers_url) }
      format.xml  { head :ok }
    end
  end

  protected
    def find_user
      if params[:user_id]
        @user = User.find(params[:user_id])
      else
        @server = Server.find(params[:id])
        @user = @server.user
      end
      unless current_user == @user
        redirect_to @user, :alert => "Permission error!"
      end
    end
end
