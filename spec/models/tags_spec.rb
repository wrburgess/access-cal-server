require "rails_helper"

describe Tag, type: :model do
  let(:tag) { FactoryGirl.create :tag }

  it "has a valid factory" do
    expect(create :tag).to be_valid
  end

  it "is invalid without a name" do
    expect(build :tag, name: nil).to_not be_valid
  end

  it "is invalid without a type" do
    expect(build :tag, tag_type: nil).to_not be_valid
  end

  it { is_expected.to have_many :events }
  it { is_expected.to have_many :event_tags }
end
