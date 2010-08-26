class ObjsController < ApplicationController
  # GET /objs
  # GET /objs.xml
  def index
  	sdk_obj_array = Array.new
  	if request.format.html? then
    	@objs = Obj.all
    else
    	with_properties = false
    	if !params[:criteria].nil? then
    		criteria = JSON.parse(params[:criteria])
    		conditions = Hash.new
    		conditions.store("app_id", params[:app_id])
    		if !criteria["user_id"].nil? then conditions.store("user_id", criteria["user_id"]) end
    		if !criteria["type"].nil? then conditions.store("obj_type", criteria["type"]) end
    		if !criteria["group_id"].nil? then conditions.store("group_id", criteria["group_id"]) end
    		if !criteria["with_properties"].nil? then
    			with_properties = true
    			@objs = Obj.find(:all, :conditions => conditions, :include => [:object_properties])
    		else
    			@objs = Obj.find(:all, :conditions => conditions)
    		end
    	else
    		@objs = Obj.find(:all, :conditions => {:app_id => params[:app_id]}, include => [:object_properties])
    	end
    	@objs.each do |obj|
    		sdk_obj = obj_to_sdk(obj, with_properties)
    		sdk_obj_array.push(sdk_obj)
    	end
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @objs }
      format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" =>
  		  { :request_id => params[:request_id].to_i, :result_code => "success", :object => sdk_obj_array }
  		} 
  	  }
    end
  end

  # GET /objs/1
  # GET /objs/1.xml
  def show
  	@obj = nil
  	object = nil
  	if request.format.html? then
    	@obj = Obj.find(params[:id], :include => [:object_properties])
   	else 
    	@obj = Obj.find(:first, :conditions => { :id => params[:id], :app_id => params[:app_id] }, :include => [:object_properties])
    end
    
    if !@obj.nil? then
    	object = obj_to_sdk(@obj, true)
    end
	
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @obj }
  	  format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" =>
  		  { :request_id => params[:request_id].to_i, :result_code => "success", :object => object }
  		} 
  	  }
    end
  end

  # GET /objs/new
  # GET /objs/new.xml
  def new
    @obj = Obj.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @obj }
    end
  end

  # GET /objs/1/edit
  def edit
    @obj = Obj.find(params[:id])
  end

  # POST /objs
  # POST /objs.xml
  def create
    @obj = nil
    sdk_properties = nil
    error = nil
    appResponse = nil
    logger.debug("RAW_POST IS: #{request.raw_post}")    
    logger.debug("RAW_POST IS: #{CGI::unescape(request.raw_post)}")    
    if request.format.html? then
    	@obj = Obj.new(params[:obj])
    else
	sdk_obj = JSON.parse(CGI::unescape(request.raw_post))
#    	sdk_obj = JSON.parse(params[:object])
	    obj_hash = sdk_obj["edu.stanford.cs.gaming.sdk.model.Obj"]
	    sdk_properties = obj_hash["object_properties"]
	    obj_hash.delete "id"
	    obj_hash.delete "object_properties"
	    obj_hash.delete "rating_count"
	    obj_hash.delete "rating_total"
	    if obj_hash["user_id"] == 0 then obj_hash.delete "user_id" end
	    if obj_hash["group_id"] == 0 then obj_hash.delete "group_id" end
	    @obj = Obj.new obj_hash
    end
    @obj.rating_count = 0
    @obj.rating_total = 0
    
    success = @obj.save
    if !success then
    	error = @obj.errors.full_messages
    	appResponse = { :request_id => params[:request_id].to_i, :result_code => "failure", :error => error, :object => nil }
    else
    	response_obj = {"id" => @obj.id}
    	if !sdk_properties.nil? then
    		response_obj.store("object_properties", Array.new)
	    	sdk_properties.each do |sdk_property|
	    		prop_hash = sdk_property["edu.stanford.cs.gaming.sdk.model.ObjProperty"]
	    		prop_hash.delete "id"
	    		prop_hash.delete "obj_id"
	    		@property = ObjectProperty.new prop_hash
	    		@property.obj_id = @obj.id
	    		success = @property.save
	    		if !success then
	    			error = @property.errors.full_messages
	    			@obj.destroy
	    			break
	    		end
	    		response_obj["object_properties"].push( { "edu.stanford.cs.gaming.sdk.model.ObjProperty" => { "object_id" => @obj.id, "id" => @property.id } } )
	    	end
	    end
	    appResponse = { :request_id => params[:request_id].to_i, :result_code => "success", :object => 
	    	{ "edu.stanford.cs.gaming.sdk.model.Obj" => response_obj } 
	    }
    end
   
    respond_to do |format|
      if success
        flash[:notice] = 'Obj was successfully created.'
        format.html { redirect_to(@obj) }
        format.xml  { render :xml => @obj, :status => :created, :location => @obj }
        format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" => appResponse } }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @obj.errors, :status => :unprocessable_entity }
        format.json { render:json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" =>  appResponse } }
      end
    end
  end

  # PUT /objs/1
  # PUT /objs/1.xml
  def update
    @obj = Obj.find(params[:id])

    respond_to do |format|
      if @obj.update_attributes(params[:obj])
        flash[:notice] = 'Obj was successfully updated.'
        format.html { redirect_to(@obj) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @obj.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /objs/1
  # DELETE /objs/1.xml
  def destroy
  	if request.format.html? then
    	@obj = Obj.find(params[:id])
    	@obj.destroy
   	else
   		@obj = Obj.find(:first, :conditions => { :id => params[:id], :app_id => params[:app_id] })
   		if !@obj.nil? then
   			@obj.destroy
   		end
   	end

    respond_to do |format|
      format.html { redirect_to(objs_url) }
      format.xml  { head :ok }
      format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" => 
      		{ :request_id => params[:request_id].to_i, :result_code => "success", :object => nil } 
      	}
      }
    end
  end
  
  def add_rating
  	success = false #default value
  	@obj = Obj.find(params[:id])
  	if !@obj.nil? then
  		criteria = JSON.parse(params[:criteria])
  		rating = criteria["rating"].to_i
  		@obj.rating_count = @obj.rating_count + 1
  		@obj.rating_total = @obj.rating_total + rating
  		success = @obj.save
  		if !success then
  			error = @obj.errors.full_messages
  		end
  	else
  		error = "Obj not found."
  	end
  	
  	respond_to do |format|
	  	if success then
		  	format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" => 
		      		{ :request_id => params[:request_id].to_i, :result_code => "success", :object => nil } 
		    	}
		    }
		else
			format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" => 
		      		{ :request_id => params[:request_id].to_i, :result_code => "failure", :error => error, :object => nil } 
		    	}
		    }
		end
	end
  end
  
  private
  
  def obj_to_sdk(obj, with_properties) 
  	properties = nil;
  	if with_properties
	  	properties = Array.new
	  	obj.object_properties.each do |property|
	  		sdk_prop = case property.prop_type
	  			when 0 then { "edu.stanford.cs.gaming.sdk.model.ObjProperty" => 
	  				{ :obj_id => property.obj_id, :id => property.id, :name => property.name, :prop_type => property.prop_type, :int_val => property.int_val }
	  			} 
	  			when 1 then { "edu.stanford.cs.gaming.sdk.model.ObjProperty" => 
	  				{ :obj_id => property.obj_id, :id => property.id, :name => property.name, :prop_type => property.prop_type, :float_val => property.float_val }
	  			}
	  			when 2 then { "edu.stanford.cs.gaming.sdk.model.ObjProperty" => 
	  				{ :obj_id => property.obj_id, :id => property.id, :name => property.name, :prop_type => property.prop_type, :string_val => property.string_val }
	  			}
	  			when 3 then { "edu.stanford.cs.gaming.sdk.model.ObjProperty" => 
	  				{ :obj_id => property.obj_id, :id => property.id, :name => property.name, :prop_type => property.prop_type, :blob_val => property.blob_val }
	  			}
	  		end
	  		properties.push(sdk_prop)
	  	end
	end  
  	if obj.user_id.nil? then
	  	sdk_obj = { "edu.stanford.cs.gaming.sdk.model.Obj" => 
	  		{ :id => obj.id, :app_id => obj.app_id, :group_id => obj.group_id, :obj_type => obj.obj_type, :object_properties => properties, :rating_count => obj.rating_count, :rating_total => obj.rating_total } 
	  	}
	else
		sdk_obj = { "edu.stanford.cs.gaming.sdk.model.Obj" => 
	  		{ :id => obj.id, :app_id => obj.app_id, :user_id => obj.user_id, :obj_type => obj.obj_type, :object_properties => properties, :rating_count => obj.rating_count, :rating_total => obj.rating_total } 
	  	}
	end
  end
  
end
