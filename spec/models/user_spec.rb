require 'rails_helper'

RSpec.describe User, user_type: :model do
  before(:each) do
    @user = User.new(
      name: "Irfan",
      email: "irfan@mail.com",
      password: "qwerty123",
      phone_number: "081234567890",
    )
  end

  it "will save when name, email, password, and phone_number are present" do
    user = @user
    expect(user.save).to eq(true)
  end

  it "will not save when name is not present" do
    user = @user
    user.name = nil
    expect(user.save).to eq(false)
  end

  it "will not save when email is not present" do
    user = @user
    user.email = nil
    expect(user.save).to eq(false)
  end

  it "will not save when password is not present" do
    user = @user
    user.password = nil
    expect(user.save).to eq(false)
  end
end
