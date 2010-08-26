class ObjectPropertiesController < ApplicationController
  # GET /object_properties
  # GET /object_properties.xml
  def index
  	response_array = nil
  	if request.format.html? then
    	@object_properties = ObjectProperty.all
    else
    	if !params[:criteria].nil? then
    		criteria = JSON.parse(params[:criteria])
    		conditions = Hash.new
    		obj_conditions = Hash.new
    		obj_conditions.store("app_id", params[:app_id])
    		if !criteria["user_id"].nil? then obj_conditions.store("user_id", criteria["user_id"]) end
    		if !criteria["group_id"].nil? then obj_conditions.store("group_id", criteria["group_id"]) end
    		if !criteria["obj_type"].nil? then obj_conditions.store("obj_type", criteria["obj_type"]) end
    		if !criteria["name"].nil? then conditions.store("name", JSON.parse(criteria["name"])) end
    		conditions.store("objs", obj_conditions);
    		@object_properties = ObjectProperty.find(:all, :joins => :obj, :conditions => conditions)
    	else
    		@object_properties = ObjectProperty.find(:all, :joins => :obj, :conditions => { :objs => { :app_id => params[:app_id] } })
    	end
    	response_array = Array.new
    	@object_properties.each do |property|
    		sdk_prop = case property.prop_type
	  			when 0 then { "edu.stanford.cs.gaming.sdk.model.ObjProperty" => 
	  			{ :obj_id => property.obj_id, :id => property.id, :name => property.name, :prop_type => property.prop_type, :int_val => property.int_val } } 
	  			when 1 then { "edu.stanford.cs.gaming.sdk.model.ObjProperty" => 
	  			{ :obj_id => property.obj_id, :id => property.id, :name => property.name, :prop_type => property.prop_type, :float_val => property.float_val } }
	  			when 2 then { "edu.stanford.cs.gaming.sdk.model.ObjProperty" => 
	  			{ :obj_id => property.obj_id, :id => property.id, :name => property.name, :prop_type => property.prop_type, :string_val => property.string_val } }
	  			when 3 then { "edu.stanford.cs.gaming.sdk.model.ObjProperty" => 
	  			{ :obj_id => property.obj_id, :id => property.id, :name => property.name, :prop_type => property.prop_type, :blob_val => property.blob_val } }
	  		end
	  		response_array.push(sdk_prop)
    	end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @object_properties }
      format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" => 
      			{ :request_id => params[:request_id].to_i, :result_code => "success", :object => response_array } 
      		}
      	}
    end
  end

  # GET /object_properties/1
  # GET /object_properties/1.xml
  def show
    @object_property = ObjectProperty.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @object_property }
    end
  end

  # GET /object_properties/new
  # GET /object_properties/new.xml
  def new
    @object_property = ObjectProperty.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @object_property }
    end
  end

  # GET /object_properties/1/edit
  def edit
    @object_property = ObjectProperty.find(params[:id])
  end

  # POST /object_properties
  # POST /object_properties.xml
  def create
  	success = false #default value
  	responseArray = nil
  	error = nil
  	@object_property = nil
  	if request.format.html? then
    	@object_property = ObjectProperty.new(params[:object_property])
    	success = @object_property.save
   	else
   		sdk_prop_array = JSON.parse(CGI::unescape(request.raw_post))
   		saved_props = Array.new
   		sdk_prop_array.each do |sdk_property|
   			prop_hash = sdk_property["edu.stanford.cs.gaming.sdk.model.ObjProperty"]
    		prop_hash.delete "id"
    		@property = ObjectProperty.new prop_hash
    		success = @property.save
    		if success then
    			saved_props.push(@property)
    		else
    			error = @property.errors.full_messages
    			saved_props.each do |false_prop|
    				false_prop.destroy
    			end
    			break
    		end
   		end
   		if success
   			response_array = Array.new
   			saved_props.each do |saved_prop|
   				response_array.push( { "edu.stanford.cs.gaming.sdk.model.ObjProperty" => { :id => saved_prop.id } } )
   			end
   		end
   	end
	
    respond_to do |format|
      if success
        flash[:notice] = 'ObjectProperties was successfully created.'
        format.html { redirect_to(@object_property) }
        format.xml  { render :xml => @object_property, :status => :created, :location => @object_property }
        format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" => 
      			{ :request_id => params[:request_id].to_i, :result_code => "success", :object => response_array } 
      		}
      	}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @object_property.errors, :status => :unprocessable_entity }
        format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" => 
      			{ :request_id => params[:request_id].to_i, :result_code => "failure", :error => error, :object => nil } 
      		}
      	}
      end
    end
  end

  # PUT /object_properties/1
  # PUT /object_properties/1.xml
  def update
  	success = false #default value
  	error = nil
  	if request.format.html? then
    	@object_property = ObjectProperty.find(params[:id])
    	success = @object_property.update_attributes(params[:object_property])
    else
    	sdk_prop_array = JSON.parse(CGI::unescape(request.raw_post))
    	sdk_prop_array.each do |sdk_property|
    		prop_hash = sdk_property["edu.stanford.cs.gaming.sdk.model.ObjProperty"]
    		property = ObjectProperty.find(prop_hash["id"])
    		prop_hash.delete "id"
    		prop_hash.delete "obj_id"
    		success = property.update_attributes(prop_hash)
    		if !success then
    			error = property.errors.full_messages
    			break
    		end
    	end
    end
    
    respond_to do |format|
      if success
        flash[:notice] = 'ObjectProperties was successfully updated.'
        format.html { redirect_to(@object_property) }
        format.xml  { head :ok }
        format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" => 
      			{ :request_id => params[:request_id].to_i, :result_code => "success", :object => nil } 
      		}
      	}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @object_property.errors, :status => :unprocessable_entity }
        format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" => 
      			{ :request_id => params[:request_id].to_i, :result_code => "failure", :error => error, :object => nil } 
      		}
      	}
      end
    end
  end

  # DELETE /object_properties/1
  # DELETE /object_properties/1.xml
  def destroy
  	if request.format.html? then
    	@object_property = ObjectProperty.find(params[:id])
    	@object_property.destroy
    else
    	prop_id_array = JSON.parse(CGI::unescape(request.raw_post))
    	prop_id_array.each do |prop_id|
    		property = ObjectProperty.find(prop_id)
    		if !property.nil? then
    			property.destroy
    		end
    	end
    end

    respond_to do |format|
      format.html { redirect_to(object_properties_url) }
      format.xml  { head :ok }
      format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" => 
      		{ :request_id => params[:request_id].to_i, :result_code => "success", :object => nil } 
      	}
      }
    end
  end
end
