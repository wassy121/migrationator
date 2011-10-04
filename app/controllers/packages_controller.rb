class PackagesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_server

  # GET /servers/2/packages
  def index
    @server = Server.find(params[:server_id])
    @packages = @server.packages
  end

  # GET /servers/2/packages/3
  def show
    @server = Server.find(params[:server_id])
    @package = @server.packages.find(params[:id])
  end

  # GET /servers/2/packages/new
  def new
    @server = Server.find(params[:server_id])
    @package = @server.packages.build
  end

  # GET /servers/2/packages/3/edit
  def edit
    @server = Server.find(params[:server_id])
    @package = Package.find(params[:id])
  end

  # POST /servers/2/packages
  def create
    @package = Package.new(params[:package])
    @package.server = Server.find(params[:server_id])

    if @package.save
      flash[:notice] = 'Package was successfully created.'
      redirect_to server_url(@package.server)
    else
      render :action => "new" 
    end
  end

  # PUT /servers/1/packages/2
  def update
    @package = Package.find(params[:id])
    @server = Server.find(params[:server_id])
    if @package.update_attributes(params[:package])
      flash[:notice] = 'Package was successfully updated.'
      redirect_to server_url(@server)
    else
      render :action => "edit" 
    end
  end

  # DELETE /server/1/packages/2
  def destroy
    @package = Package.find(params[:id])
    @package.destroy

    respond_to do |format|
      format.html { redirect_to(server_packages_url) }
      format.xml  { head :ok }
    end
  end

  protected
    def find_server
      if params[:server_id]
        @server = Server.find(params[:server_id])
        @user = @server.user
      else
        @package = Package.find(params[:id])
        @user = @package.server.user
      end
      unless current_user == @user
        redirect_to @user, :alert => 'Permission error!'
      end
    end
end
