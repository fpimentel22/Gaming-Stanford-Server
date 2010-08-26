class ScoreBoardsController < ApplicationController
  # GET /score_boards
  # GET /score_boards.xml
  def index
  	response_array = nil
  	@score_boards = nil
  	if request.format.html? then
   		@score_boards = ScoreBoard.all
   	else
   		if !params[:criteria].nil? then
   			criteria = JSON.parse(params[:criteria])
   			conditions = Hash.new
   			conditions.store("app_id", params[:app_id])
   			if !criteria["user_id"].nil? then conditions.store("user_id", criteria["user_id"]) end
   			if !criteria["group_id"].nil? then conditions.store("group_id", criteria["group_id"]) end
   			if !criteria["type"].nil? then conditions.store("sb_type", criteria["type"]) end
   			if !criteria["order"].nil? then
   				if criteria["order"] == "asc" || criteria["order"] == "ASC" then
   					@score_boards = ScoreBoard.find(:all, :conditions => conditions, :order => "value ASC")
   				else
   					@score_boards = ScoreBoard.find(:all, :conditions => conditions, :order => "value DESC")
   				end
   			else
   				@score_boards = ScoreBoard.find(:all, :conditions => conditions)
   			end
   		else
   			@score_boards = ScoreBoard.find(:all, :conditions => { :app_id => params[:app_id] })
   		end
   		if !@score_boards.nil? then
   			response_array = Array.new
   			@score_boards.each do |sb|
   				sdk_sb = { "edu.stanford.cs.gaming.sdk.model.ScoreBoard" => 
    				{ :id => sb.id, :app_id => sb.app_id, :user_id => sb.user_id, :group_id => sb.group_id, :value => sb.value, :sb_type => sb.sb_type }
    			}
    			response_array.push(sdk_sb)
   			end
   		end
   	end
   	
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @score_boards }
      format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" =>
      		{ :request_id => params[:request_id].to_i, :result_code => "success", :object => response_array }
      	}
      }
    end
  end

  # GET /score_boards/1
  # GET /score_boards/1.xml
  def show
    @score_board = ScoreBoard.find(params[:id])
    response_object = nil
    if request.format.json? then
    	response_object = { "edu.stanford.cs.gaming.sdk.model.ScoreBoard" => 
    		{ :id => @score_board.id, :app_id => @score_board.app_id, :user_id => @score_board.user_id, :group_id => @score_board.group_id, :value => @score_board.value, :sb_type => @score_board.sb_type }
    	}
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @score_board }
      format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" =>
      		{ :request_id => params[:request_id].to_i, :result_code => "success", :object => response_object }
      	}
      }
    end
  end
  
  def get_user_scoreboards
  	@score_boards = ScoreBoard.find_by_sql "SELECT * FROM `score_boards` WHERE user_id > 0"
  	response_array = Array.new
	@score_boards.each do |sb|
		sdk_sb = { "edu.stanford.cs.gaming.sdk.model.ScoreBoard" => 
			{ :id => sb.id, :app_id => sb.app_id, :user_id => sb.user_id, :group_id => sb.group_id, :value => sb.value, :sb_type => sb.sb_type }
		}
		response_array.push(sdk_sb)
	end
	respond_to do |format|
      format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" =>
      		{ :request_id => params[:request_id].to_i, :result_code => "success", :object => response_array }
      	}
      }
    end
  end
  
  def get_group_scoreboards
  	@score_boards = ScoreBoard.find_by_sql "SELECT * FROM `score_boards` WHERE group_id > 0"
  	response_array = Array.new
	@score_boards.each do |sb|
		sdk_sb = { "edu.stanford.cs.gaming.sdk.model.ScoreBoard" => 
			{ :id => sb.id, :app_id => sb.app_id, :user_id => sb.user_id, :group_id => sb.group_id, :value => sb.value, :sb_type => sb.sb_type }
		}
		response_array.push(sdk_sb)
	end
	respond_to do |format|
      format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" =>
      		{ :request_id => params[:request_id].to_i, :result_code => "success", :object => response_array }
      	}
      }
    end
  end
  
  def get_scoreboards_by_ids
  	criteria = JSON.parse(params[:criteria])
  	score_board_ids = JSON.parse(criteria["scoreBoardIds"])
  	@score_boards = ScoreBoard.find(:all, :conditions => { :id => score_board_ids, :app_id => params[:app_id] })
  	response_array = Array.new
	@score_boards.each do |sb|
		sdk_sb = { "edu.stanford.cs.gaming.sdk.model.ScoreBoard" => 
			{ :id => sb.id, :app_id => sb.app_id, :user_id => sb.user_id, :group_id => sb.group_id, :value => sb.value, :sb_type => sb.sb_type }
		}
		response_array.push(sdk_sb)
	end
	respond_to do |format|
      format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" =>
      		{ :request_id => params[:request_id].to_i, :result_code => "success", :object => response_array }
      	}
      }
    end
  end
  

  # GET /score_boards/new
  # GET /score_boards/new.xml
  def new
    @score_board = ScoreBoard.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @score_board }
    end
  end

  # GET /score_boards/1/edit
  def edit
    @score_board = ScoreBoard.find(params[:id])
  end

  def post_multiple
  	success = false #default value
  	error = nil
  	score_boards_json = JSON.parse(CGI::unescape(request.raw_post))
	score_board_ids = Array.new
	score_boards_json.each do  |score_board_json| 
		begin
			score_board_json = score_board_json["edu.stanford.cs.gaming.sdk.model.ScoreBoard"]
			score_board_json.delete "id" 
			score_board = ScoreBoard.new(score_board_json)
			score_board.save
			score_board_ids.push score_board.id 
		rescue
		
		end

	end
    respond_to do |format|
        format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" =>
      			{ :request_id => params[:request_id].to_i, :result_code => "success", :object => score_board_ids }
      		}
      	}
    end
  end

  def put_multiple
  	success = false #default value
  	error = nil
  	score_boards_json = JSON.parse(CGI::unescape(request.raw_post))
	score_board_ids = Array.new
	score_boards_json.each do  |score_board_json| 
#		begin
			score_board_json = score_board_json["edu.stanford.cs.gaming.sdk.model.ScoreBoard"]
			score_board = ScoreBoard.find(score_board_json["id"])
			score_board.update_attributes(score_board_json)
			score_board.save
			score_board_ids.push score_board.id 
#		rescue
		
#		end

	end
    respond_to do |format|
        format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" =>
      			{ :request_id => params[:request_id].to_i, :result_code => "success", :object => score_board_ids }
      		}
      	}
    end
  end


  # POST /score_boards
  # POST /score_boards.xml
  def create
  	success = false #default value
  	error = nil
  	@score_board = nil
  	if request.format.html? then
    	@score_board = ScoreBoard.new(params[:score_board])
    	success = @score_board.save
    else
    	sdk_sb = JSON.parse(CGI::unescape(request.raw_post))
    	sb_hash = sdk_sb["edu.stanford.cs.gaming.sdk.model.ScoreBoard"]
    	sb_hash.delete "id"
    	@score_board = ScoreBoard.new(sb_hash)
    	success = @score_board.save
    	if ! success then
    		error = @score_board.errors.full_messages
    	end
    end

    respond_to do |format|
      if success
        flash[:notice] = 'ScoreBoard was successfully created.'
        format.html { redirect_to(@score_board) }
        format.xml  { render :xml => @score_board, :status => :created, :location => @score_board }
        format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" =>
      			{ :request_id => params[:request_id].to_i, :result_code => "success", :object => @score_board.id }
      		}
      	}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @score_board.errors, :status => :unprocessable_entity }
        format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" =>
      			{ :request_id => params[:request_id].to_i, :result_code => "failure", :error => error, :object => nil }
      		}
      	}
      end
    end
  end

  # PUT /score_boards/1
  # PUT /score_boards/1.xml
  def update
  	success = false #default value
  	error = nil
  	@score_board = ScoreBoard.find(params[:id])
  	if request.format.html? then
    	success = @score_board.update_attributes(params[:score_board])
    else
    	sdk_scoreboard = JSON.parse(CGI::unescape(request.raw_post))
    	sb_hash = sdk_scoreboard["edu.stanford.cs.gaming.sdk.model.ScoreBoard"]
    	if !@score_board.nil? then
	    	sb_hash.delete "id"
	    	sb_hash.delete "app_id"
	    	sb_hash.delete "user_id"
	    	sb_hash.delete "group_id"
	    	success = @score_board.update_attributes(sb_hash)
		    if !success then
		    	error = @score_board.errors.full_messages
		    end
		else
			error = "ScoreBoard not found."
		end
    end
    respond_to do |format|
      if success
        flash[:notice] = 'ScoreBoard was successfully updated.'
        format.html { redirect_to(@score_board) }
        format.xml  { head :ok }
        format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" =>
      			{ :request_id => params[:request_id].to_i, :result_code => "success", :object => nil }
      		}
      	}
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @score_board.errors, :status => :unprocessable_entity }
        format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" =>
      			{ :request_id => params[:request_id].to_i, :result_code => "failure", :object => nil }
      		}
      	}
      end
    end
  end

  # DELETE /score_boards/1
  # DELETE /score_boards/1.xml
  def destroy
    @score_board = ScoreBoard.find(params[:id])
    @score_board.destroy

    respond_to do |format|
      format.html { redirect_to(score_boards_url) }
      format.xml  { head :ok }
      format.json { render :json => { "edu.stanford.cs.gaming.sdk.model.AppResponse" =>
      		{ :request_id => params[:request_id].to_i, :result_code => "success", :object => nil }
      	}
      }
    end
  end
end
