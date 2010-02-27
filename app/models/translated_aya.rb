class TranslatedAya
  include DataMapper::Resource

  property :sura_number, Integer, :key => true
  property :aya_number, Integer, :key => true
  property :translation_id, Integer, :key => true
  property :text, Text, :lazy => false, :required => true

  belongs_to :sura, :child_key => [ :sura_number ]
  belongs_to :aya, :child_key => [ :sura_number, :aya_number ]
  belongs_to :translation, :model => QuranTranslation, :child_key => [ :translation_id ]


end
