# frozen_string_literal: true

RSpec.describe ClearLogic::Service do
  let(:stub_name) { FFaker::Lorem.word }

  class InterfaceService < ClearLogic::Service
    context :name, Dry::Types['strict.string']
    context :params, Dry::Types['strict.hash'], optional: true, default: -> { {} }
  end

  context 'Interface' do
    context 'Strong first parameter' do
      it 'success build' do
        result = InterfaceService.call(name: stub_name)

        expect(result).to be_success
        expect(result.context.name).to eq(stub_name)
        expect(result.context.params).to eq({})
      end

      it 'failure build' do
        expect { InterfaceService.call(name: 5, params: {}) }.to raise_error(Dry::Types::ConstraintError)
      end
    end

    context 'Optional second option' do
      it 'success build' do
        result = InterfaceService.call(name: stub_name, params: { test: 5 })

        expect(result).to be_success
        expect(result.context.name).to eq(stub_name)
        expect(result.context.params).to eq({ test: 5 })
      end

      it 'failure build' do
        expect { InterfaceService.call(name: stub_name, params: 5) }.to raise_error(Dry::Types::ConstraintError)
      end
    end
  end
end
