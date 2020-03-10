# frozen_string_literal: true

require_relative '../../../formatter/phone_number/uk'

RSpec.describe Formatter::PhoneNumber::UK do
  shared_examples 'formatted phone number' do
    it 'returns formatted phone number' do
      is_expected.to eq '+447123456789'
    end
  end

  describe '.format' do
    subject { described_class.format(number) }

    context 'valid phone number' do
      context 'starts from +447...' do
        let(:number) { '+4471234 56789' }

        it_behaves_like 'formatted phone number'
      end

      context 'starts from 447...' do
        let(:number) { '44 71234 56789' }

        it_behaves_like 'formatted phone number'
      end

      context 'starts from 07...' do
        let(:number) { '07 1234 56789' }

        it_behaves_like 'formatted phone number'
      end
    end

    context 'invalid phone number' do
      context 'invald prefix' do
        context 'with 0634343' do
          let(:number) { '0634343' }

          it 'raises error' do
            expect { subject }
              .to raise_error(Formatter::PhoneNumber::UK::InvalidPrefix)
          end
        end

        context 'does not have 7 after prefix with 4401234 56789' do
          let(:number) { '4401234 56789' }

          it 'raises error' do
            expect { subject }
              .to raise_error(Formatter::PhoneNumber::UK::InvalidPrefix)
          end
        end
      end

      context 'invalid digits length' do
        context 'with 071234 5678' do
          let(:number) { '071234 5678' }

          it 'raises error' do
            expect { subject }
              .to raise_error(Formatter::PhoneNumber::UK::InvalidDigitLength)
          end
        end

        context 'with +447 12345678' do
          let(:number) { '+447 12345678' }

          it 'raises error' do
            expect { subject }
              .to raise_error(Formatter::PhoneNumber::UK::InvalidDigitLength)
          end
        end
      end

      context 'contains invalid character' do
        let(:number) { '4401234 bb6789' }

        it 'raises error' do
          expect { subject }
            .to raise_error(Formatter::PhoneNumber::UK::InvalidPhoneNumber)
        end
      end

      context 'with nil' do
        let(:number) { nil }

        it 'raises error' do
          expect { subject }
            .to raise_error(Formatter::PhoneNumber::UK::InvalidPhoneNumber)
        end
      end
    end
  end
end
