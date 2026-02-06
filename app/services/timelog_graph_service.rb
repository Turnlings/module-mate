class TimelogGraphService
  def initialize(user, scope, cumulative: true)
    @user = user
    @scope = scope
    @cumulative = cumulative
  end

  def call
    modules = case @scope
              when User, Year, Semester then @scope.uni_modules
              when UniModule then [@scope]
              else []
              end

    # All cases but UniModule
    modules = modules.includes(:timelogs) if modules.is_a?(ActiveRecord::Relation)

    modules.map do |mod|
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
