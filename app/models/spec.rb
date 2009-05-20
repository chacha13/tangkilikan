class Spec < ActiveRecord::Base
  belongs_to :user
  acts_as_ferret
  
ALL_FIELDS = %w(pangalan apelyido trabaho kasarian kaarawan 
kalye lungsod probinsya)
STRING_FIELDS = %w(pangalan apelyido trabaho kalye lungsod probinsya)
VALID_GENDERS = ["Lalaki", "Babae"]
START_YEAR = 1900
VALID_DATES = DateTime.new(START_YEAR)..DateTime.now


              
validates_inclusion_of :kasarian,
                       :in => VALID_GENDERS,
                       :allow_nil => true,
                       :message => "dapat lalaki o babae lamang"
validates_inclusion_of :kaarawan,
                       :in => VALID_DATES,
                        :allow_nil => true,
                        :message => "ay di valid"
#Search on last name
def self.search_on_apelyido(name_initial)
    find(:all, :conditions => ["apelyido like ?", name_initial + '%'],
          :order => "apelyido, pangalan" ) 
end

# Return the age using the birthdate.
def age
  return if kaarawan.nil?
    today = Date.today
  if today.month >= kaarawan.month and today.day >= kaarawan.day
    # Birthday has happened already this year.
    today.year - kaarawan.year
  else
      today.year - kaarawan.year - 1
  end
end

# Return the full name (first plus last).
def full_name
    [pangalan, apelyido].join(" ")
end
# Return a sensibly formatted location string.
def location
    [kalye, lungsod, probinsya].join(" ")
end
# Find by age, sex, location.
def self.find_by_asl(params)
  where = []
  # Set up the age restrictions as birthdate range limits in SQL.
    unless params[:min_age].blank?
      where << "ADDDATE(kaarawan, INTERVAL :min_age YEAR) < CURDATE()"
    end
    unless params[:max_age].blank?
      where << "ADDDATE(kaarawan, INTERVAL :max_age+1 YEAR) > CURDATE()"
    end
# Set up the gender restriction in SQL.
  where << "kasarian = :kasarian" unless params[:kasarian].blank?
  if where.empty?
    []  
  else
    find( :all,
          :conditions => [where.join(" AND "), params],
          :order => "apelyido, pangalan")
  end
  # Set up the city restriction in SQL.
  where << "lungsod= :lungsod" unless params[:lungsod].blank?
  if where.empty?
    []  
  else
    find( :all,
          :conditions => [where.join(" AND "), params],
          :order => "apelyido, pangalan")
  end
# Set up the job restriction in SQL.
  where << "trabaho = :trabaho" unless params[:trabaho].blank?
  if where.empty?
    []  
  else
    find( :all,
          :conditions => [where.join(" AND "), params],
          :order => "apelyido, pangalan")
  end

end
end
