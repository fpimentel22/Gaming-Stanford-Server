class UsersController < ApplicationController
  
  def get_friends
  	@users = nil
  	
  	@friends = Friend.find(:all, :select => :friend_id, :conditions => { :user_id => params[:id] } )
	friend_id_array = Array.new
	@friends.each do |friend|
		friend_id_array.push friend.friend_id
	end
	
  	if !params[:criteria].nil?
  		#then this is get invitable friends
  		criteria = JSON.parse(params[:criteria])
  		@users = User.find(:all, :joins => :apps, :conditions => { :id => friend_id_array, :apps => { :id => criteria["app_id"] } } )
  	else
  		# then this is get friends
  		@users = User.find(:all, :conditions => { :id => friend_id_array} )
  	end
  	
  	response_array = Array.new
  	@users.each do |user|
  		sdk_user = { "edu.stanford.cs.gaming.sdk.model.User" => 
    		{ :id => user.id, :first_name => user.first_name, :last_name => user.last_name, :email => user.email, :fb_id => user.fb_id, :fb_photo => user.fb_photo } 
    	}
    	response_array.push sdk_user
  	end
  	
  	respond_to do |format|
  		format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" =>
  				{ :request_id => params[:request_id].to_i, :result_code => "success", :object => response_array }
  	 		}
  	 	}
  	end
  end
  
  # GET /users
  # GET /users.xml
  def index
  	@users = nil
  	if request.format.html? then
    	@users = User.all
    else
    	@users = User.find(:all, :joins => :apps, :conditions => { :apps => { :id => params[:app_id] } } )
    end
    
    response_array = Array.new
  	@users.each do |user|
  		sdk_user = { "edu.stanford.cs.gaming.sdk.model.User" => 
    		{ :id => user.id, :first_name => user.first_name, :last_name => user.last_name, :email => user.email, :fb_id => user.fb_id, :fb_photo => user.fb_photo  } 
    	}
    	response_array.push sdk_user
  	end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
      format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" =>
  				{ :request_id => params[:request_id].to_i, :result_code => "success", :object => response_array }
  	 		}
  	 	}
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    object = nil
    if request.format.json? then
    	if !@user.nil? then
    		object = { "edu.stanford.cs.gaming.sdk.model.User" => 
    			{ :id => user.id, :first_name => @user.first_name, :last_name => @user.last_name, :email => @user.email, :fb_id => @user.fb_id, :fb_photo => user.fb_photo  } 
    		}
    	end
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
      format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" =>
  		  { :request_id => params[:request_id].to_i, :result_code => "success", :object => object }
  		}
  	  }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
  	@user = nil
  	success = false #default value
  	friends_list = nil
  	if request.format.html? then
    	@user = User.new(params[:user])
    	success = @user.save
    else
    	sdk_user = JSON.parse(CGI::unescape(request.raw_post))
    	user_hash = sdk_user["edu.stanford.cs.gaming.sdk.model.User"]
    	user_hash.delete "id"
    	friends_list = user_hash["friend_fb_ids"]
    	user_hash.delete "friend_fb_ids"
    	# test to see if the user already exists
    	@user = User.find(:first, :conditions => {:email => user_hash["email"]})
    	if @user.nil? then
	    	@user = User.new(user_hash)
	    	success = @user.save
	    	if success then
	    		@app_user = AppsUser.new
	    		@app_user.app_id = params[:app_id]
	    		@app_user.user_id = @user.id
	    		@app_user.save
	    	end
	    else
	    	success = true
	    end
    end
    
    if success then
    	if !friends_list.nil? then
    		friends = User.find(:all, :select => :id, :conditions => { :fb_id => friends_list } )
    		logger.error friends
    		friends.each do |friend|
    			#create link one way
    			link = Friend.new
    			link.user_id = @user.id
    			link.friend_id = friend.id
    			link.save
    			#create reverse link
    			rev_link = Friend.new
    			rev_link.user_id = friend.id
    			rev_link.friend_id = @user.id
    			rev_link.save
    		end
    	end
    end
    
    respond_to do |format|
      if success
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(@user) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
        format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" =>
  		  		{ :request_id => params[:request_id].to_i, :result_code => "success", :object => @user.id }
  			}
  		} 
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" =>
  		  		{ :request_id => params[:request_id].to_i, :result_code => "failure", :error => @user.errors.full_messages, :object => nil }
  			}
  		} 
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
