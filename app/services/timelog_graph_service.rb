class TimelogGraphService
  def initialize(user, scope)
    @user = user
    @scope = scope
  end

  def call
    modules = case @scope
              when User then @scope.uni_modules
              when Year then @scope.uni_modules
              when Semester then @scope.uni_modules
              when UniModule then [@scope]
              else []
              end

    modules.includes(:timelogs).map do |mod|
      {
        name: mod.name,
        data: cumulative_for(mod)
      }
    end
  end

  private

  def cumulative_for(mod)
    total = 0
    mod.timelogs.for_user(@user).group_by_day(:date).sum(:minutes)
       .transform_values { |m| total += m }
  end
end