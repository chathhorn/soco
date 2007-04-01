module LongTermHelper

  def lookup_semester time
    if (time.month == 12 or time.month < 5)
      return 'SP'
    elsif (time.month < 8)
      return 'SU'
    else
      return 'FA'
    end
  end

  def lookup_semester_word time
    code = lookup_semester time
    if (code == 'SP')
      return 'Spring'
    elsif (code == 'FA')
      return 'Fall'
    else (code == 'SU')
      return 'Summer'
    end
  end
  
  def lookup_year time
    if (time.month == 12) 
      return (time.year + 1).to_s;
    else 
      return time.year.to_s
    end
  end
end