class QuranController < ApplicationController
  def index
    @suras = Sura.all

    respond_to do |format|
      format.html
      format.xml  { render :xml => @suras }
    end
  end

  def sura
    sura_number = params[:sura_number]
    @sura = Sura.first :conditions => { :number => sura_number }
    @ayas = @sura.ayas

    respond_to do |format|
      format.html
      format.xml  { render :xml => @sura }
    end
  end
end
