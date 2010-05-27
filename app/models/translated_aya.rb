class TranslatedAya
  include Mongoid::Document

  field :text

  embedded_in :aya, :inverse_of => :translations
  belongs_to_related :quran_translation


  def to_s
    text
  end
end
