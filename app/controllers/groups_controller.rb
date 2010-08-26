class GroupsController < ApplicationController
  # GET /groups
  # GET /groups.xml
  def get_by_criteria(criteria, app_id)
  	groups = nil
  	limit = criteria["limit"].to_i || 0
	rowsRet = criteria["rowsRet"].to_i || 0
	user_filter = criteria["user_id"]
	name_filter = criteria["name"]

	conditions = Hash.new
	conditions.store("app_id", app_id)
	if !name_filter.nil? then conditions.store("name", name_filter) end
	if !user_filter.nil? then conditions.store("groups_users", {"user_id" => user_filter}) end
	offset = limit * rowsRet
	
	if !user_filter.nil? then #search join table for groups that the user is part of
		if rowsRet > 0 then # use pagination
			groups = Group.find(:all, :joins => :groups_users, :conditions => conditions, :offset => offset, :limit => rowsRet)
		else # assume that no pagination is specified
			groups = Group.find(:all, :joins => :groups_users, :conditions => conditions)
		end
	else # search groups table
		if rowsRet > 0 then # use pagination
			groups = Group.find(:all, :conditions => conditions, :offset => offset, :limit => rowsRet)
		else # assume that no pagination is specified
			groups = Group.find(:all, :conditions => conditions)
		end
	end
	return groups	
  end
  
  def index
  	#function to return a list of groups, sdk: getGroups(int request_id, String name, int user_id, int limit, int rowsRet)
  	@groups = nil
  	appResponse = nil
  	if request.format.json? then 
  		if !params[:criteria].nil? then
  			@groups = get_by_criteria(JSON.parse(params[:criteria]), params[:app_id])
  		else
  			@groups = Group.find(:all, :conditions => { :app_id => params[:app_id]})
  		end

		object = nil
		object_array = Array.new
		@groups.each do |group|
			group_users_array = Array.new
			group.users.each do |u| 
                        group_user_json = { "edu.stanford.cs.gaming.sdk.model.User" => { :id => u.user_id.to_i, :first_name => u.first_name, :last_name => u.last_name, :email => u.email, :fb_id => u.fb_id, :fb_photo => u.fb_photo } }
			group_users_array.push(group_user_json)
			end
			item = { "edu.stanford.cs.gaming.sdk.model.Group" => { :id => group.id, :name => group.name, :owner_id => group.owner_id, :users => group_users_array } }

			object_array.push(item)
		end
		object = object_array
		appResponse = { :request_id => params[:request_id].to_i, :result_code => "success", :object => object }
		logger.error appResponse
	else 
		@groups = Group.all
	end
	
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
      format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" => appResponse } }
    end
    
  end

  # GET /groups/1
  # GET /groups/1.xml
  def show
  	if request.format.json? then
  		@group = Group.find(params[:id], :conditions => { :app_id => params[:app_id].to_i } )
  	else
  		@group = Group.find(params[:id])
  	end
    
	group_users_array = Array.new
	group.users.each do |u| 
           group_user_json = { "edu.stanford.cs.gaming.sdk.model.User" => { :id => u.user_id.to_i, :first_name => u.first_name, :last_name => u.last_name, :email => u.email, :fb_id => u.fb_id, :fb_photo => u.fb_photo } }
	   group_users_array.push(group_user_json)
	end
	object = { "edu.stanford.cs.gaming.sdk.model.Group" => { :id => @group.id, :name => @group.name, :owner_id => group.owner_id, :users => group_users_array } }
	result_code = "success"
	
	appResponse = { :request_id => params[:request_id].to_i, :result_code => result_code, :object => object }
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" => appResponse } }
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.xml
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.xml
  def create
  	#this function receives a post request from SDK and returns the integer group_id of the newly created group
  	@group = nil
  	if request.format.html? then
  		@group = Group.new(params[:group])
  	else
  		sdk_group = JSON.parse(CGI::unescape(request.raw_post))
		group_hash =  sdk_group["edu.stanford.cs.gaming.sdk.model.Group"]
		group_hash.delete "id"
		group_hash.delete "users"
		@group = Group.new(group_hash)
  	end
  	success = @group.save
  	
    respond_to do |format|
      if success
        flash[:notice] = 'Group was successfully created.'
        format.html { redirect_to(@group) }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
        format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" => 
        		{ :request_id => params[:request_id].to_i, :result_code => "success", 
        			:object => @group.id }
        	}
        }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
        format.json { render :json =>  { "edu.stanford.cs.gaming.sdk.model.AppResponse" => 
        		{ :request_id => params[:request_id].to_i, :result_code => "failure", :error => @group.errors.full_messages, 
        			:object => nil }
        	}
        }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  def update
  	success = false # default value
  	error = nil
  	@group = nil
  	if request.format.html? then
  		@group = Group.find(params[:id])
  		success = @group.update_attributes(params[:group])
  	else
  		@group = Group.find(:first, :conditions => { :id => params[:id], :app_id => params[:app_id] } )
  		if !@group.nil? then
  			sdk_group = JSON.parse(CGI::unescape(request.raw_post))
    		group_hash = sdk_group["edu.stanford.cs.gaming.sdk.model.Group"]
    		success = @group.update_attribute("name", group_hash["name"])
    		if !success then
    			error = @group.errors.full_messages
    		end
  		else
  			error = "Group not found."
  		end
  	end

    respond_to do |format|
      if success
        flash[:notice] = 'Group was successfully updated.'
        format.html { redirect_to(@group) }
        format.xml  { head :ok }
        format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" => 
        		{ :request_id => params[:request_id].to_i, :result_code => "success", :object => nil }
        	} 
        }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
        format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" => 
        		{ :request_id => params[:request_id].to_i, :result_code => "failure", :error => error, :object => nil }
        	} 
        }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.xml
  def destroy
  	if request.format.html? then
  		@group = Group.find(params[:id])
  	else 
  		@group = Group.find(params[:id], :conditions => { :app_id => params[:app_id].to_i } )
  	end
    
    @group.users.delete #delete all groups users associations in table
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(groups_url) }
      format.xml  { head :ok }
	  format.json { render :json =>  { "edu.stanford.cs.gaming.sdk.model.AppResponse" => 
		  { :request_id => params[:request_id].to_i, :result_code => "success", :object => nil }
	  	}
	  }
    end
    
  end
  
  
  
end