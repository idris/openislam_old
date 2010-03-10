class Aya
  include DataMapper::Resource

  property :id, Serial
  property :sura_number, Integer, :unique_index => :sura_aya
  property :number, Integer, :unique_index => :sura_aya
  property :text, Text, :required => true, :lazy => false

  belongs_to :sura, :child_key => [ :sura_number ]
  has n, :translations, :model => TranslatedAya, :child_key => [ :sura_number, :aya_number ]


  def translation(tid=1)
    translations.get(sura_number, number, tid)
  end

  def to_s
    "#{sura_number}:#{number}"
  end
end
