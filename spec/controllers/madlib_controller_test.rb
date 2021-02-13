require 'rails_helper'
RSpec.describe MadlibController, type: :controller do
  
  let(:madlib) { MadlibController.new }
  let (:valid_sentence) {'It was a {adjective} day. I went downstairs to see if I could {verb} dinner. I asked, "Does the stew need fresh {noun}?'}

  describe '#Sentence' do
    let (:nil_sentence) {''}
    let (:case_senstive_sentence) {'It was a {Adjective} day. I went downstairs to see if I could {verb} dinner. I asked, "Does the stew need fresh {noun}?'}
    let (:incorrect_sentence) {'It was a {Adjective} day'}  

    it 'contains atleast one adjective, noun, verb - is valid' do 
      madlib.instance_variable_set(:@sentence, valid_sentence)
      expect(madlib.valid_sentence).to be true
    end

    it 'contains nil and not valid' do 
      madlib.instance_variable_set(:@sentence, nil_sentence)
      expect(madlib.valid_sentence).to be false
    end

    it 'case senstivity is valid' do 
      madlib.instance_variable_set(:@sentence, case_senstive_sentence)
      expect(madlib.valid_sentence).to be true
    end

    it 'not contain atleast one verb, noun or adjective' do
      madlib.instance_variable_set(:@sentence, incorrect_sentence)
      expect(madlib.valid_sentence).to be false
    end

    it 'contains madlib words - verb' do 
      madlib.instance_variable_set(:@sentence, valid_sentence)
      madlib.instance_variable_set(:@connection, madlib.connection('verb'))      
      expect(madlib.replace_words('verb')).to eq('Run')
    end

    it 'contain madlib words - noun' do 
      madlib.instance_variable_set(:@sentence, valid_sentence)
      madlib.instance_variable_set(:@connection, madlib.connection('noun'))      
      expect(madlib.replace_words('noun')).to eq('Onions')
    end

    it 'contain madlib words - adjective' do 
      madlib.instance_variable_set(:@sentence, valid_sentence)
      madlib.instance_variable_set(:@connection, madlib.connection('adjective'))      
      expect(madlib.replace_words('adjective')).to eq('Sunny')
    end
  end

  describe '#Construction Request' do    
    before do
      allow(Rails.application.config).to receive(:word_fetch).and_return('https://reminiscent-steady-albertosaurus.glitch.me/')
    end    
    
    it 'is valid for verb' do 
      expect(madlib.construct_connection('verb')).to eq('https://reminiscent-steady-albertosaurus.glitch.me/verb')
    end
    
    it 'is valid for noun' do 
      expect(madlib.construct_connection('noun')).to eq('https://reminiscent-steady-albertosaurus.glitch.me/noun')
    end
    
    it 'is valid for adjective' do 
      expect(madlib.construct_connection('adjective')).to eq('https://reminiscent-steady-albertosaurus.glitch.me/adjective')
    end
  end

  describe '#Faraday connection' do 
    it 'contains ok status for noun request' do 
      expect(madlib.connection('noun').status).to eq(200)
    end

    it 'contains ok status for verb request' do 
      expect(madlib.connection('verb').status).to eq(200)
    end

    it 'contains ok status for adjective request' do 
      expect(madlib.connection('adjective').status).to eq(200)
    end

    it 'contains valid header for verb request' do 
      expect(madlib.connection('verb').headers['content-type']).to eq('application/json; charset=utf-8')
    end

    it 'contains valid header for noun request' do 
      expect(madlib.connection('noun').headers['content-type']).to eq('application/json; charset=utf-8')
    end

    it 'contains valid header for adjective request' do 
      expect(madlib.connection('adjective').headers['content-type']).to eq('application/json; charset=utf-8')
    end

    it 'contains 404 status for an invalid request' do 
      madlib.instance_variable_set(:@connection, madlib.connection('verb1'))
      expect(madlib.connection_response_status).to eq(404)
    end

    it 'contains no json headers for an invalid request' do 
      madlib.instance_variable_set(:@connection, madlib.connection('verb1'))
      expect(madlib.connection_response_header).to be false
    end
  end
end