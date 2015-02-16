class WelcomePolicy < Struct.new(:user, :welcome)
  def index?
    user
  end
end
