class TimelogGraphService
  def initialize(user, scope, cumulative: true, date_since_s: "all")
    @user = user
    @scope = scope
    @cumulative = cumulative
    @date_since_s = date_since_s
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
    start_date = date_of(@date_since_s)

    raw_scope = mod.timelogs.for_user(@user)
    raw_scope = raw_scope.where("date >= ?", start_date) if start_date.present?

    raw = raw_scope.group_by_day(:date).sum(:minutes)
    return raw unless @cumulative

    total = 0
    raw.transform_values { |m| total += m }
  end

  def date_of(since_string)
    case since_string
    when "all"
      start_date = nil
    when "1_week"
      start_date = 1.week.ago.to_date
    when "1_month"
      start_date = 1.month.ago.to_date
    when "3_months"
      start_date = 3.months.ago.to_date
    when "6_months"
      start_date = 6.months.ago.to_date
    end

    return start_date
  end
end
