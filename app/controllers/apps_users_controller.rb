class AppsUsersController < ApplicationController
  # GET /apps_users
  # GET /apps_users.xml
  def index
    @apps_users = AppsUsers.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @apps_users }
    end
  end

  # GET /apps_users/1
  # GET /apps_users/1.xml
  def show
    @apps_users = AppsUsers.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @apps_users }
    end
  end

  # GET /apps_users/new
  # GET /apps_users/new.xml
  def new
    @apps_users = AppsUsers.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @apps_users }
    end
  end

  # GET /apps_users/1/edit
  def edit
    @apps_users = AppsUsers.find(params[:id])
  end

  # POST /apps_users
  # POST /apps_users.xml
  def create
    @apps_users = AppsUsers.new(params[:apps_users])

    respond_to do |format|
      if @apps_users.save
        flash[:notice] = 'AppsUsers was successfully created.'
        format.html { redirect_to(@apps_users) }
        format.xml  { render :xml => @apps_users, :status => :created, :location => @apps_users }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @apps_users.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /apps_users/1
  # PUT /apps_users/1.xml
  def update
    @apps_users = AppsUsers.find(params[:id])

    respond_to do |format|
      if @apps_users.update_attributes(params[:apps_users])
        flash[:notice] = 'AppsUsers was successfully updated.'
        format.html { redirect_to(@apps_users) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @apps_users.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /apps_users/1
  # DELETE /apps_users/1.xml
  def destroy
    @apps_users = AppsUsers.find(params[:id])
    @apps_users.destroy

    respond_to do |format|
      format.html { redirect_to(apps_users_url) }
      format.xml  { head :ok }
    end
  end
end
