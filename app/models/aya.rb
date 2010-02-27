class Aya
  include DataMapper::Resource

  property :sura_number, Integer, :key => true
  property :number, Integer, :key => true
  property :text, Text, :required => true, :lazy => false

  belongs_to :sura, :child_key => [ :sura_number ]
  has n, :translated_ayas, :child_key => [ :sura_number, :aya_number ]


  def to_s
    "#{sura_number}:#{number}"
  end
end
