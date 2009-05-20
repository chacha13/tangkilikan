class CommunityController < ApplicationController
helper :profile


def index
@title = "Community"
@letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")
if params[:id]
@initial = params[:id]
 if params[:id] 
    @initial  = params[:id] 
    curr_page = params[:page]
   specs = Spec.search_on_apelyido(@initial)
   users = specs.collect { |spec| spec.user }
   @users = users.paginate(:page => curr_page, :per_page => 10)
    end
end
end

def browse
  @title = "Browse"
  return if params[:commit].nil?
  curr_page = params[:page]
  specs = Spec.find_by_asl(params)
 @users = specs.collect { |spec| spec.user }
 @users = @users.paginate(:page => curr_page, :per_page => 10)
end

def search
  if params[:q]
  query = params[:q]
   curr_page = params[:page]
  # First find the user hits...
  @users = User.find_by_contents(query, :limit => :all)
  # ...then the subhits.
  specs = Spec.find_by_contents(query, :limit => :all)
  faqs = Faq.find_by_contents(query, :limit => :all)
  # Now combine into one list of distinct users sorted by last name.
  hits = specs + faqs
   @users.concat(hits.collect { |hit| hit.user }).uniq!
  # Sort by last name (requires a spec for each user).
  @users = @users.each { |user| user.spec ||= Spec.new }
  @users = @users.sort_by { |user| user.spec.apelyido }
  @users = @users.paginate(:page => curr_page, :per_page => 10)
 
    end
end
end