require 'timeout'

def get_gist_from params
    (Gist.where(:key => params[:id]))[0]
end

class GistsController < ApplicationController

  def show_image
    @gist = get_gist_from params 
    if @gist.nil?
      respond_to do |format|
        format.html { render :file => '#{Rails.root}/public/404.html',  :status => 404 }
        format.json { render :json => {} }
      end
    else
      if @gist.image_status == 'finished'
        @gist.image_status = 'wait'
        @gist.save
      end
      respond_to do |format|
        format.all do
          if @gist.image_status == 'loading'
            render :text => 'Currently loading'
          elsif @gist.image_status == 'tle'
            render :text => 'Image is not available because it takes too long to render.'
          else
            render :text => 'Not available yet'
          end
        end
      end
    end
  end

  def show
    @gist = get_gist_from params
    if @gist.nil?
      respond_to do |format|
        format.all { render :text => 'Not found.' }
      end
    else
      @current_url = request.url
      puts short_gist_simple_path(@gist, :only_path => false)
      respond_to do |format|
        format.html {
          if params[:show_type] == 'raw'
            render :layout => false, :template => 'gists/show_raw'
          elsif params[:show_type] == 'simple'
            render :layout => false, :template => 'gists/show_simple'
          end
        }
        format.json { render :json => @gist }
      end
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
