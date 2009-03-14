module Typus

  def self.to_sentence_options(connector = '&')
    if Rails.version == '2.2.2'
      { :skip_last_comma => true, :connector => connector }
    else
      { :words_connector => ', ', :last_word_connector => " #{connector} " }
    end
  end

  def self.roles_sentence
    Typus::Configuration.roles.keys.sort.to_sentence(Typus.to_sentence_options('or'))
  end

end