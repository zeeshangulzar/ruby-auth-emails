require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with email and password" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "is invalid without an email" do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it "is invalid with a duplicate email" do
      create(:user, email: "dup@example.com")
      user = build(:user, email: "dup@example.com")
      expect(user).not_to be_valid
    end
  end

  describe "#confirmed?" do
    it "returns true for a confirmed user" do
      user = build(:user)
      expect(user.confirmed?).to be true
    end

    it "returns false for an unconfirmed user" do
      user = build(:unconfirmed_user)
      expect(user.confirmed?).to be false
    end
  end
end
