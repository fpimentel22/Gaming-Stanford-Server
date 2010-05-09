class GroupsUsersController < ApplicationController
  # GET /groups_users
  # GET /groups_users.xml
  def index
    @groups_users = GroupsUsers.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups_users }
    end
  end

  # GET /groups_users/1
  # GET /groups_users/1.xml
  def show
    @groups_users = GroupsUsers.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @groups_users }
    end
  end

  # GET /groups_users/new
  # GET /groups_users/new.xml
  def new
    @groups_users = GroupsUsers.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @groups_users }
    end
  end

  # GET /groups_users/1/edit
  def edit
    @groups_users = GroupsUsers.find(params[:id])
  end

  # POST /groups_users
  # POST /groups_users.xml
  def create
    @groups_users = GroupsUsers.new(params[:groups_users])

    respond_to do |format|
      if @groups_users.save
        flash[:notice] = 'GroupsUsers was successfully created.'
        format.html { redirect_to(@groups_users) }
        format.xml  { render :xml => @groups_users, :status => :created, :location => @groups_users }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @groups_users.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groups_users/1
  # PUT /groups_users/1.xml
  def update
    @groups_users = GroupsUsers.find(params[:id])

    respond_to do |format|
      if @groups_users.update_attributes(params[:groups_users])
        flash[:notice] = 'GroupsUsers was successfully updated.'
        format.html { redirect_to(@groups_users) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @groups_users.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groups_users/1
  # DELETE /groups_users/1.xml
  def destroy
    @groups_users = GroupsUsers.find(params[:id])
    @groups_users.destroy

    respond_to do |format|
      format.html { redirect_to(groups_users_url) }
      format.xml  { head :ok }
    end
  end
end
