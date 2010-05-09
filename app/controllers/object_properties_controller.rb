class ObjectPropertiesController < ApplicationController
  # GET /object_properties
  # GET /object_properties.xml
  def index
    @object_properties = ObjectProperties.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @object_properties }
    end
  end

  # GET /object_properties/1
  # GET /object_properties/1.xml
  def show
    @object_properties = ObjectProperties.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @object_properties }
    end
  end

  # GET /object_properties/new
  # GET /object_properties/new.xml
  def new
    @object_properties = ObjectProperties.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @object_properties }
    end
  end

  # GET /object_properties/1/edit
  def edit
    @object_properties = ObjectProperties.find(params[:id])
  end

  # POST /object_properties
  # POST /object_properties.xml
  def create
    @object_properties = ObjectProperties.new(params[:object_properties])

    respond_to do |format|
      if @object_properties.save
        flash[:notice] = 'ObjectProperties was successfully created.'
        format.html { redirect_to(@object_properties) }
        format.xml  { render :xml => @object_properties, :status => :created, :location => @object_properties }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @object_properties.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /object_properties/1
  # PUT /object_properties/1.xml
  def update
    @object_properties = ObjectProperties.find(params[:id])

    respond_to do |format|
      if @object_properties.update_attributes(params[:object_properties])
        flash[:notice] = 'ObjectProperties was successfully updated.'
        format.html { redirect_to(@object_properties) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @object_properties.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /object_properties/1
  # DELETE /object_properties/1.xml
  def destroy
    @object_properties = ObjectProperties.find(params[:id])
    @object_properties.destroy

    respond_to do |format|
      format.html { redirect_to(object_properties_url) }
      format.xml  { head :ok }
    end
  end
end
