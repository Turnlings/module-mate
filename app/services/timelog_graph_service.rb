class TimelogGraphService
  def initialize(user, scope, cumulative: true)
    @user = user
    @scope = scope
    @cumulative = cumulative
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
        data: processed_data(mod)
      }
    end
  end

  private

  def processed_data(mod)
    raw = mod.timelogs.for_user(@user).group_by_day(:date).sum(:minutes)
    return raw unless @cumulative

    total = 0
    raw.transform_values { |m| total += m }
  end
end
