def get_gist_from params
    (Gist.where(:key => params[:id]))[0]
end

class GistsController < ApplicationController

  def show_simple
    @gist = get_gist_from params
    if @gist.nil?
      @isnil = true
    end
    
    respond_to do |format|
      format.html { render :layout => false}
    end
  end

  def show_raw
    @gist = get_gist_from params
    if @gist.nil?
      @isnil = true
    end
    
    respond_to do |format|
      format.html { render :layout => false}
    end
  end

  def show
    @gist = get_gist_from params
    if @gist.nil?
      @isnil = true
    end
    
    @current_url = request.url

    respond_to do |format|
      format.html
      format.json { render :json => @gist }
    end
  end

  def new
    @gist = Gist.new

    respond_to do |format|
      format.html
      format.json { render :json => @gist }
    end
  end

  def create
    if request.method != 'POST'
      redirect_to '/'
    else
      params[:gist][:key] = (SecureRandom.base64(30).gsub(/[\/+=]/, ''))[0...8]
      @gist = Gist.new(params[:gist])

      respond_to do |format|
        if @gist.save
          format.html { redirect_to short_gist_path(@gist), :notice => 'Gist was successfully created.' }
          format.json { render :json => @gist, :status => :created, :location => @gist }
        else
          format.html { redirect_to gist_new_path }
          format.json { render :json => @gist.errors, :status => :unprocessable_entity }
        end
      end
    end
  end
end
