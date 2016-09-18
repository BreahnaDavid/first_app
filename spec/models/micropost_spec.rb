require 'rails_helper'

describe Micropost do
  subject { micropost }

  let(:user) { create(:user) }

  let(:micropost) do
    create(
      :micropost,
      content: 'Blabla',
    )
  end

  it { is_expected.to respond_to(:content) }

  it { is_expected.to respond_to(:user_id) }
end
