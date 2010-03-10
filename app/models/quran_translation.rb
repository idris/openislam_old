class QuranTranslation
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :unique => true
  property :translator, String
  property :source_name, String
  property :source_url, URI

  has n, :translated_ayas, :child_key => [ :translation_id ]

  validates_is_unique :name


end
