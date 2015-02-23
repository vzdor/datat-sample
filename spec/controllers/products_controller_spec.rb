require 'rails_helper'

RSpec.describe ProductsController do
  describe '#index' do
    context 'with html format' do
      it 'renders successfully' do
        get :index
        expect(response).to be_success
      end
    end

    context 'with json format' do
      it 'renders succ...' do
        get :index, format: :json
        expect(response).to be_success
      end
    end

  end
end
