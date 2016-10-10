require 'rails_helper'

RSpec.describe Node, type: :model do
  let(:title) { "status" }
  let(:content) { "real life #hello #world" }

  subject do
    Node.create(
      title: title,
      content: content,
    )
  end

  it 'should identify tags' do
    expect(subject.tags).to eql(%w[ hello world ])
  end
end
