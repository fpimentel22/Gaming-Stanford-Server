class ScoreBoardsController < ApplicationController
  # GET /score_boards
  # GET /score_boards.xml
  def index
    @score_boards = ScoreBoard.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @score_boards }
    end
  end

  # GET /score_boards/1
  # GET /score_boards/1.xml
  def show
    @score_board = ScoreBoard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @score_board }
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

  # POST /score_boards
  # POST /score_boards.xml
  def create
    @score_board = ScoreBoard.new(params[:score_board])

    respond_to do |format|
      if @score_board.save
        flash[:notice] = 'ScoreBoard was successfully created.'
        format.html { redirect_to(@score_board) }
        format.xml  { render :xml => @score_board, :status => :created, :location => @score_board }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @score_board.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /score_boards/1
  # PUT /score_boards/1.xml
  def update
    @score_board = ScoreBoard.find(params[:id])

    respond_to do |format|
      if @score_board.update_attributes(params[:score_board])
        flash[:notice] = 'ScoreBoard was successfully updated.'
        format.html { redirect_to(@score_board) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @score_board.errors, :status => :unprocessable_entity }
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
    end
  end
end
