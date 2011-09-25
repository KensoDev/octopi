require 'spec_helper'

describe Octopi::User do
  before do
    api_stub("users/fcoury")
    api_stub("users/fcoury/gists")
  end

  it "can find a user" do
    user = Octopi::User.find("fcoury")
    user.login.should == "fcoury"
  end

  it "can find a user's gist" do
    Octopi::User.find("fcoury").gists
  end

  context "authenticated" do
    before do
      Octopi.authenticate!(:username => "radar", :password => "password")
      stub_request(:get, authenticated_base_url + "user").to_return(fake("users/me"))
    end

    it "can find the authenticated user" do
      user = Octopi::User.me
      user.login.should == "radar"
    end
  
    it "can update the authenticated user's details" do
      url =  authenticated_base_url + "user"

      user = Octopi::User.me
      user.name.should == "Ryan Bigg"
      stub_request(:put, url).to_return(fake("users/updated"))
      user = Octopi::User.update(:name => "Super Ryan")

      WebMock.should have_requested(:put, url).with(:body => { :name => "Super Ryan"}.to_json)
      user.name.should == "Super Ryan"
    end
  end
end