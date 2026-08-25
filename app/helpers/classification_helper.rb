module ClassificationHelper
  def classification(percent)
    case percent
    when 70.. then '1st'
    when 60...70 then '2:1'
    when 50...60 then '2:2'
    when 40...50 then '3rd'
    when 1...40 then 'Fail'
    else '...'
    end
  end
end
