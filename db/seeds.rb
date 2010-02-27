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
    sura.number = s['index']
    sura.name = s['name']
    sura.tname = s['tname']
    sura.ename = s['ename']
    sura.type = s['type']
    sura.order = s['order']
    begin
      sura.save
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
    sura_number = s['index']
    s['aya'].each do |a|
      aya = Aya.new
      aya.sura_number = sura_number
      aya.number = a['index']
      aya.text = a['text']
      begin
        aya.save
      rescue DataObjects::IntegrityError
        error "Database is not clean."
        return false
      end
      info "Loaded Aya #{aya.to_s}"
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
      t = TranslatedAya.new
      t.sura_number = aya.sura_number
      t.aya_number = aya.number
      t.translation = translation
      t.text = line
      begin
        t.save
      rescue DataObjects::IntegrityError
        error "Database is not clean."
        return false
      end
      info "[#{translation.name}] #{aya.to_s}"
    end
  end
end

def load_translations
  translation = QuranTranslation.new
  translation.name = 'Yusuf Ali'
  translation.translator = 'Abdullah Yusuf Ali'
  translation.source_name = 'Zekr.org'
  translation.source_url = 'http://zekr.org/resources.html'
  translation.save
  import_translation_text('db/data/zekr/yusufali.txt', translation)

  translation = QuranTranslation.new
  translation.name = 'Shakir'
  translation.translator = 'Mohammad Habib Shakir'
  translation.source_name = 'Zekr.org'
  translation.source_url = 'http://zekr.org/resources.html'
  translation.save
  import_translation_text('db/data/zekr/shakir.txt', translation)

  translation = QuranTranslation.new
  translation.name = 'Pickthall'
  translation.translator = 'Mohammed Marmaduke William Pickthall'
  translation.source_name = 'Zekr.org'
  translation.source_url = 'http://zekr.org/resources.html'
  translation.save
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
