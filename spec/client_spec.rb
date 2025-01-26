require 'spec_helper'
require 'code_review_ai'

RSpec.describe CodeReviewAi::Client, type: :class do
  let(:api_token) { 'test_token' }
  let(:ai_model) { 'gpt-3.5-turbo-0125' }
  let(:language) { 'English' }
  let(:code_review_ai) { described_class.new(api_token, ai_model, language) }
  let(:api_response) do
    { 'choices' => [{ 'message' => { 'content' => target_msg } }] }
  end

  describe '#generate_branch_summary' do
    context 'when successful' do
      let(:target_msg) { 'Test summary' }

      before do
        allow_any_instance_of(OpenAI::Client).to receive(:chat).and_return(api_response)
      end

      it 'returns the summary' do
        output = StringIO.new
        $stdout = output
        code_review_ai.generate_branch_summary
        $stdout = STDOUT
        expect(output.string.chomp).to eq('Test summary')
      end
    end

    context 'when API fails' do
      before do
        allow_any_instance_of(OpenAI::Client).to receive(:chat).and_raise(StandardError.new('API error'))
      end

      it 'returns error message' do
        expect(code_review_ai.generate_branch_summary).to eq('Error generating branch summary: API error')
      end
    end
  end
end
