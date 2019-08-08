require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  # let (:user) { User.new(username: 'bob', password: '123456') }
  # FactoryBot.build(:user)
  subject(:bob) { 
    User.create(
      username: 'bob',
      password: '123456'
    )
  }
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }
  it { should validate_presence_of(:password_digest) }
  it { should validate_presence_of(:session_token) }
  it { should validate_uniqueness_of(:session_token) }
  it { should validate_presence_of(:password) }

  describe "User#ensure_session_token" do
    it "should not reassign an existing session token" do
      session_token = bob.session_token
      bob.ensure_session_token 
      expect(bob.session_token).to eq(session_token)
    end
  end

  describe "User#password=" do
    it "should create password digest based on the users passsword" do
      expect(BCrypt::Password.new(bob.password_digest).is_password?("123456")).to be(true)
    end
  end

  describe "User#reset_session_token!" do
    it "should reset the session_token" do
      session_token = bob.session_token
      bob.reset_session_token!
      expect(session_token).not_to eq(bob.session_token)
    end

    it "should return the session_token" do
      expect(bob.reset_session_token!).to eq(bob.session_token) 
    end
  end

  describe "User#is_password?" do
    it "should confirm the supplied password is the user's password" do 
      expect(bob.is_password?("123456")).to be(true)
      expect(bob.is_password?("1234567")).to be(false)
    end
  end

  describe "User::find_by_credentials" do
    subject(:bob) { 
      User.create(
        username: 'bob',
        password: '123456'
      )
    }
    it "should find a user based on username" do
      ted = FactoryBot.create(:user, username: 'ted')
      expect(User.find_by_credentials("ted", "123456")).to eq(ted)
    end

    it "should return nil if user does not exist" do
      expect(User.find_by_credentials("bobe", "123456")).to be(nil)
    end

    it "should return nil if password is incorrect" do 
      FactoryBot.create(:user, username: 'bob')
      expect(User.find_by_credentials("bob", "1234567")).to be(nil)
    end
  end

end
