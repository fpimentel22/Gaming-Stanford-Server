class ObjectsController < ApplicationController
  # GET /objects
  # GET /objects.xml
  def index
    @objects = Objects.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @objects }
    end
  end

  # GET /objects/1
  # GET /objects/1.xml
  def show
    @objects = Objects.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @objects }
    end
  end

  # GET /objects/new
  # GET /objects/new.xml
  def new
    @objects = Objects.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @objects }
    end
  end

  # GET /objects/1/edit
  def edit
    @objects = Objects.find(params[:id])
  end

  # POST /objects
  # POST /objects.xml
  def create
    @objects = Objects.new(params[:objects])

    respond_to do |format|
      if @objects.save
        flash[:notice] = 'Objects was successfully created.'
        format.html { redirect_to(@objects) }
        format.xml  { render :xml => @objects, :status => :created, :location => @objects }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @objects.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /objects/1
  # PUT /objects/1.xml
  def update
    @objects = Objects.find(params[:id])

    respond_to do |format|
      if @objects.update_attributes(params[:objects])
        flash[:notice] = 'Objects was successfully updated.'
        format.html { redirect_to(@objects) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @objects.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /objects/1
  # DELETE /objects/1.xml
  def destroy
    @objects = Objects.find(params[:id])
    @objects.destroy

    respond_to do |format|
      format.html { redirect_to(objects_url) }
      format.xml  { head :ok }
    end
  end
end
