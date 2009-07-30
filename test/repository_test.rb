require File.join(File.dirname(__FILE__), 'test_helper')

class RepositoryTest < Test::Unit::TestCase
  include Octopi
  
  def setup
    fake_everything
    @user = User.find("fcoury")
    @private_repos = authenticated_with("fcoury", "8f700e0d7747826f3e56ee13651414bd") do
      @user.repositories
    end
    @repository = @user.repositories.find("octopi")
  end

  
  context Repository do
    
    should "return a repository for a user" do
      assert_not_nil @user.repository(:name => "octopi")
    end
    
    should "return a repository for a login" do
      assert_not_nil Repository.find(:user => "fcoury", :name => "octopi")
    end
    
    should "be able to look up the repository based on the user and name" do
      assert_not_nil Repository.find(:user => @user, :name => "octopi")
    end
    
    should "return repositories" do
      assert_equal 43, @user.repositories.size
    end
    
    should "return more repositories if authed" do
      assert_equal 44, @private_repos.size
    end
    
    should "not return a repository when asked for a private one" do
      assert_raises NotFound do
        @user.repository(:name => "rboard")
      end
    end
    
    should "return a private repository when authed" do
      authenticated_with("fcoury", "8f700e0d7747826f3e56ee13651414bd") do
        assert_not_nil @user.repository(:name => "rboard")
      end
    end
  end
end
