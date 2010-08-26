class GroupsUsersController < ApplicationController
  # GET /groups_users
  # GET /groups_users.xml
  def index
    @groups_users = GroupsUser.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups_users }
    end
  end

  # GET /groups_users/1
  # GET /groups_users/1.xml
  def show
    @groups_users = GroupsUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @groups_users }
    end
  end

  # GET /groups_users/new
  # GET /groups_users/new.xml
  def new
    @groups_users = GroupsUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @groups_users }
    end
  end

  # GET /groups_users/1/edit
  def edit
    @groups_users = GroupsUser.find(params[:id])
  end

  # POST /groups_users
  # POST /groups_users.xml
  def create
  	success = false #default val
  	error = nil
  	appResponse = nil;
  	if request.format.html? then
    	@groups_users = GroupsUser.new(params[:groups_user])
    	success = @groups_users.save
    	if !success then
    		error = @groups_users.errors.full_messages
    	end
    else
    	logger.debug("RAW_POST IS: #{request.raw_post}")
    	logger.error CGI::unescape(request.raw_post)
    	sdk_user_array = JSON.parse(CGI::unescape(request.raw_post))
    	criteria = JSON.parse(params[:criteria])
    	group_id = criteria["id"] || 0
    	saved_array = Array.new
    	sdk_user_array.each do |sdk_user|
    		user_hash = sdk_user["edu.stanford.cs.gaming.sdk.model.User"]
    		groups_user = GroupsUser.new
    		groups_user.group_id = group_id
    		groups_user.user_id = user_hash["id"]
    		success = groups_user.save
    		if !success then
    			error = groups_user.errors.full_messages
    			saved_array.each do |false_entry|
    				false_entry.destroy
    			end
    			break
    		else
    			saved_array.push(groups_user);
    		end
    	end
    	
    	if success then
    		appResponse = { :request_id => params[:request_id].to_i, :result_code => "success", :object => nil }
    	else
    		appResponse = { :request_id => params[:request_id].to_i, :result_code => "failure", :error => error, :object => nil }
    	end
    	logger.error appResponse
    end
    
    respond_to do |format|
      if success
        flash[:notice] = 'GroupsUsers was successfully created.'
        format.html { redirect_to(@groups_users) }
        format.xml  { render :xml => @groups_users, :status => :created, :location => @groups_users }
        format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" => appResponse } }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @groups_users.errors, :status => :unprocessable_entity }
        format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" => appResponse } }
      end
    end
  end

  # PUT /groups_users/1
  # PUT /groups_users/1.xml
  def update
    @groups_users = GroupsUser.find(params[:id])

    respond_to do |format|
      if @groups_users.update_attributes(params[:groups_user])
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
  	if request.format.html? then 
   		@groups_users = GroupsUser.find(params[:id])
    	@groups_users.destroy
    else 
    	sdk_user_array = JSON.parse(CGI::unescape(request.raw_post))
    	group_id = params[:id]
    	sdk_user_array.each do |sdk_user|
    		user_hash = sdk_user["edu.stanford.cs.gaming.sdk.model.User"]
    		group_user = GroupsUser.find(:first, :conditions => { :group_id => group_id, :user_id => user_hash["id"] })
    		if !group_user.nil? then
    			group_user.destroy
    		end
    	end
    end

    respond_to do |format|
      format.html { redirect_to(groups_users_url) }
      format.xml  { head :ok }
      format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" => 
      		{ :request_id => params[:request_id].to_i, :result_code => "success", :object => nil } 
      	}
      }
    end
  end
end
