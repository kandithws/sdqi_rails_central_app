class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user_dashboard here. For example:
    #
    #   user_dashboard ||= User.new # guest user_dashboard (not logged in)
    #   if user_dashboard.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user_dashboard
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user_dashboard can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user_dashboard can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    user ||= User.new # guest user_dashboard (not logged in)
    if user.admin?
      can :manage, :all
      # can :access, :rails_admin       # only allow admin users to access Rails Admin
      # can :dashboard

    elsif user.member?
      can :read, [Car, TollFeeRecord, Bill] do |item|
        item.try(:user) == user
      end

      can :update_slip, [Bill] do |item|
        item.try(:user) == user
      end

      can :create, [Car]
      can :update, [Car] do |item|
        item.try(:user) == user
      end
      can :destroy, [Car] do |item|
        item.try(:user) == user
      end


    else
      can :read, [Car]
    end
  end
end
