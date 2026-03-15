class TimelogGraphService
  def initialize(user, scope, cumulative: true, date_since_s: 'all')
    @user = user
    @scope = scope
    @cumulative = cumulative
    @start_date = self.class.date_of(date_since_s)
  end

  def call
    modules = resolved_modules
    return [] if modules.empty?

    timelog_data = grouped_timelog_data(modules)
    build_chart_data(modules, timelog_data)
  end

  def self.date_of(since_string)
    case since_string
    when 'all'      then nil
    when '1_week'   then 1.week.ago.to_date
    when '1_month'  then 1.month.ago.to_date
    when '3_months' then 3.months.ago.to_date
    when '6_months' then 6.months.ago.to_date
    end
  end

  private

  def cumulative?
    @cumulative
  end

  def resolved_modules
    case @scope
    when User, Year, Semester
      @scope.uni_modules.order(:created_at).to_a
    when UniModule
      [@scope]
    else
      []
    end
  end

  def grouped_timelog_data(modules)
    module_ids = modules.map(&:id)
    scope = build_timelog_scope(module_ids)
    results = scope.group(:uni_module_id).group_by_day(:date).sum(:minutes)
    build_grouped_data_hash(results)
  end

  def build_timelog_scope(module_ids)
    scope = Timelog.for_user(@user).where(uni_module_id: module_ids)
    scope = scope.where(date: @start_date..) if @start_date
    scope
  end

  def build_grouped_data_hash(results)
    results.each_with_object(Hash.new { |h, k| h[k] = {} }) do |((mod_id, date), minutes), acc|
      acc[mod_id][date] = minutes
    end
  end

  def build_chart_data(modules, timelog_data)
    modules.filter_map.with_index do |mod, i|
      raw = timelog_data[mod.id] || {}
      next if raw.blank?

      trimmed = trim_to_active_range(raw)
      data = cumulative? ? cumulative_sum(trimmed) : trimmed.reject { |_d, m| m.to_i.zero? }
      {
        name: mod.name,
        data: data,
        color: mod.chart_color(i)
      }
    end
  end

  def trim_to_active_range(data)
    return data if data.blank?

    dates = data.keys.reject { |date| data[date].to_i.zero? }
    return data if dates.blank?

    first, last = dates.minmax
    data.select { |date, _| date.between?(first, last) }
  end

  def cumulative_sum(data)
    total = 0
    data.transform_values { |m| total += m }
  end
end
