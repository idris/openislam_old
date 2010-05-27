class QuranTranslation
  include Mongoid::Document

  field :name
  field :translator
  field :source_name
  field :source_url
  field :file_path


end
