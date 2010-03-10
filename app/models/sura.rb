class Sura
  include DataMapper::Resource

  property :number, Integer, :key => true
  property :name, String, :length => 50, :required => true
  property :tname, String, :length => 50, :required => true
  property :ename, String, :length => 50, :required => true
  property :order, Integer, :lazy => [:details]
  property :type, Enum['Meccan', 'Medinan'], :length => 7, :lazy => [:details]
  property :rukus, Integer, :lazy => [:details]

  has n, :ayas, :child_key => [ :sura_number ]
  has n, :translated_ayas, :child_key => [ :sura_number ]


  def translation(tid=1)
    translated_ayas.all(:translation_id => tid)
  end

  def to_s
    "#{number}. #{ename}"
  end
end
