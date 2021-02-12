class MadlibController < ApplicationController
  def initialize
    @sentence = 'It was a {adjective} day. I went downstairs to see if I could {verb} dinner. I asked, "Does the stew need fresh {noun}?'
    @match = ['{adjective}', '{verb}', '{noun}'] 
    @connection = {}   
  end

  def index
    if valid_sentence
      if madlib_words
        render plain: @sentence
      else 
        render plain 'Please try again later'
      end  
    else
      render plain: 'Sentence not valid. It doesnt contain atleast one verb, one adjective, one noun'
    end
  end

  # Check if a sentence contains at least one adjective, verb, and noun.
  def valid_sentence
    # Scan for ajdective, verb, noun
    m = @sentence.scan /\{[a-z]*}/
    m.sort == @match.sort
  end

  def construct_connection(word)
    Rails.application.config.word_fetch + word
  end 

  def connection(word)
    #begin
    Faraday.get construct_connection(word)
    #rescue Faraday::ConnectionFailed, Faraday::TimeoutError => e
      #e['status'] == '500'
      #e['headers'] == 'application/text; charset=utf-8'
    #end
  end

  def send_connection(word)
    @connection = connection(word)   
  end

  def madlib_words
    @sentence.scan(/(?<=[{]).+?(?=[}])/).uniq.each do |var|
      if !replace_words(var).nil?        
        @sentence.gsub!(/\{#{var}\}/, replace_words(var)) 
      else
        @sentence = 'Please try again later'        
      end
    end
  end

  def replace_words(word)
    send_connection(word)
    connection_response_body if check_response
  end
  
  def check_response
    connection_response_status == 200 && connection_response_header
  end

  def connection_response_status
    @connection.status
  end

  def connection_response_header
    @connection.headers['content-type'] == 'application/json; charset=utf-8'
  end

  def connection_response_body
    @connection.body.gsub('"','')
  end
end