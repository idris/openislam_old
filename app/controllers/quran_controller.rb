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
    @sura = Sura.get(sura_number)
    @ayas = @sura.ayas
    @translated_ayas = @sura.translation
    @zipped_ayas = @ayas.zip(@translated_ayas).flatten
#    @zipped_ayas = @ayas.zip(@sura.translation(1), @sura.translation(2), @sura.translation(3)).flatten

    respond_to do |format|
      format.html
      format.xml  { render :xml => @sura }
    end
  end
end
