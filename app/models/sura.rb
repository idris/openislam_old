class Sura
  include Mongoid::Document

  key :number, :type => Integer
  field :name
  field :tname
  field :ename
  field :order, :type => Integer
  field :revelation_period
  field :rukus, :type => Integer

  has_many_related :ayas


  def to_s
    "#{number}. #{ename}"
  end
end
