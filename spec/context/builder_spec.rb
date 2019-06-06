# frozen_string_literal: true

RSpec.describe ClearLogic::ContextBuilder do
  let(:stub_name) { FFaker::Lorem.word }
  let(:catched_error) { ClearLogic::CatchedError.new(stub_name) }
  let(:failure_error) { ClearLogic::FailureError.new(stub_name) }
  let(:my_option) { FFaker::Lorem.word }
  let(:service) { ClearLogic::Service }
  let(:stub_step) { FFaker::Lorem.word }

  let(:context_class) do
    described_class.call.class_eval do
      option :name, Dry::Types['strict.string']
    end
  end

  let(:instance) { context_class.new(name: stub_name) }

  it 'should has interface with name property' do
    expect(instance.name).to eq(stub_name)
  end

  it 'should raise argument error' do
    expect { context_class.new(another_name: stub_name) }.to raise_error(KeyError)
  end

  describe 'Abilty of adding options' do
    it 'should write and read new option' do
      instance[:my_option] = my_option

      expect(instance[:my_option]).to eq(my_option)
    end
  end

  describe '#exit_success?' do
    it 'should return true' do
      instance.exit_success = true

      expect(instance.exit_success?).to be_truthy
    end

    it 'should return false' do
      expect(instance.exit_success?).to be_falsey
    end
  end

  describe '#catched_error?' do
    it 'should return true' do
      instance.catched_error = catched_error

      expect(instance.catched_error).to eq(catched_error)
      expect(instance.catched_error?).to be_truthy
    end

    it 'should return false' do
      expect(instance.catched_error).to be_nil
      expect(instance.catched_error?).to be_falsey
    end
  end

  describe '#failure_error?' do
    it 'should return true' do
      instance.failure_error = failure_error

      expect(instance.failure_error).to eq(failure_error)
      expect(instance.failure_error?).to be_truthy
    end

    it 'should return false' do
      expect(instance.failure_error).to be_nil
      expect(instance.failure_error?).to be_falsey
    end
  end

  describe '#to_h' do
    it 'should return Hash with inforamtion' do
      instance.catched_error = catched_error
      instance.failure_error = failure_error
      instance.service = service
      instance.step = stub_step
      instance[:my_option] = my_option

      info = {
        catched_error: catched_error,
        failure_error: failure_error,
        service: service.class,
        exit_success: nil,
        step: stub_step,
        options: { my_option: my_option },
        args: [{ name: stub_name }]
      }

      expect(instance.to_h).to eq(info)
    end
  end
end
