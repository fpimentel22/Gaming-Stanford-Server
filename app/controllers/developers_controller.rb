class DevelopersController < ApplicationController
  # GET /developers
  # GET /developers.xml
  def index
    @developers = Developer.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @developers }
    end
  end

  # GET /developers/1
  # GET /developers/1.xml
  def show
    @developers = Developer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @developers }
    end
  end

  # GET /developers/new
  # GET /developers/new.xml
  def new
    @developers = Developer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @developers }
    end
  end

  # GET /developers/1/edit
  def edit
    @developers = Developer.find(params[:id])
  end

  # POST /developers
  # POST /developers.xml
  def create
    @developers = Developer.new(params[:developers])

    respond_to do |format|
      if @developers.save
        flash[:notice] = 'Developers was successfully created.'
        format.html { redirect_to(@developers) }
        format.xml  { render :xml => @developers, :status => :created, :location => @developers }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @developers.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /developers/1
  # PUT /developers/1.xml
  def update
    @developers = Developer.find(params[:id])

    respond_to do |format|
      if @developers.update_attributes(params[:developers])
        flash[:notice] = 'Developers was successfully updated.'
        format.html { redirect_to(@developers) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @developers.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /developers/1
  # DELETE /developers/1.xml
  def destroy
    @developers = Developer.find(params[:id])
    @developers.destroy

    respond_to do |format|
      format.html { redirect_to(developers_url) }
      format.xml  { head :ok }
    end
  end
end
