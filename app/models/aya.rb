class Aya
  include Mongoid::Document

  field :number, :type => Integer
  field :text
  key :sura_id, :number

  belongs_to_related :sura
  embeds_many :translations, :class_name => "TranslatedAya"

  index :sura_id

  def to_s
    "#{sura_number}:#{number}"
  end
end
