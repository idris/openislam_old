# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
require 'xmlsimple'

def info(str)
  print str + "\n"
#  RAILS_DEFAULT_LOGGER.info(str)
end

def error(str)
  print "ERROR: #{str}\n"
#  RAILS_DEFAULT_LOGGER.error(str)
end

def load_suras
  data = XmlSimple.xml_in('db/data/tanzil/quran-data.xml')
  data['suras'][0]['sura'].each do |s|
    sura = Sura.new
    sura.attributes = {
      :number => s['index'], 
      :name => s['name'], 
      :tname => s['tname'], 
      :ename => s['ename'], 
      :type => s['type'], 
      :order => s['order']
    }
    begin
      sura.save!
    rescue DataObjects::IntegrityError
      error "Database is not clean."
      return false
    end
    info "Loaded Sura #{sura.number}"
  end
end

def load_ayas
  data = XmlSimple.xml_in('db/data/tanzil/quran-uthmani.xml')
  data['sura'].each do |s|
    sura = Sura.get(s['index'])
    s['aya'].each do |a|
      aya = sura.ayas.new
      aya.attributes = {
        :sura => sura,
        :number => a['index'],
        :text => a['text']
      }
      info "#{aya.sura_number}:#{aya.number}"
    end
    begin
      sura.save!
    rescue DataObjects::IntegrityError
      error "Database is not clean."
      return false
    end
  end
end

def import_translation_text(path, translation)
  info "Importing #{translation.name} translation"
  File.open(path, 'r') do |f|
    ayas = Aya.all(:order => [ :sura_number, :number ])
    ayas.each do |aya|
      line = f.gets
      raise EOFError.new("Translation file [#{path}] ended preemtively on aya #{aya.to_s}") if !line || line.length <= 1
      line = line.strip()
      t = translation.translated_ayas.new
      t.attributes = {
        :sura_number => aya.sura_number,
        :aya_number => aya.number,
        :translation => translation,
        :text => line
      }
      info "[#{translation.name}] #{aya.to_s}"
    end
  end

  begin
    translation.save!
  rescue DataObjects::IntegrityError
    error "Database is not clean."
    return false
  end
end

def load_translations
  translation = QuranTranslation.new
  translation.attributes = {
    :name => 'Yusuf Ali',
    :translator => 'Abdullah Yusuf Ali',
    :source_name => 'Zekr.org',
    :source_url => 'http://zekr.org/resources.html'
  }
  translation.save!
  import_translation_text('db/data/zekr/yusufali.txt', translation)

  translation = QuranTranslation.new
  translation.attributes = {
    :name => 'Shakir',
    :translator => 'Mohammad Habib Shakir',
    :source_name => 'Zekr.org',
    :source_url => 'http://zekr.org/resources.html'
  }
  translation.save!
  import_translation_text('db/data/zekr/shakir.txt', translation)

  translation = QuranTranslation.new
  translation.attributes = {
    :name => 'Pickthall',
    :translator => 'Mohammad Marmaduke William Pickthall',
    :source_name => 'Zekr.org',
    :source_url => 'http://zekr.org/resources.html'
  }
  translation.save!
  import_translation_text('db/data/zekr/pickthall.txt', translation)
end

info "========== Loading Tanzil =========="
load_suras
info "========== Done with Suras =========="
load_ayas
info "========== Done with Ayas =========="
load_translations
info "========== Done with Translations =========="
# load_morphology
# info "========== Done with Morphology =========="
