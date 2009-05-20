class String
# Return an alternate string if blank.
    def or_else(alternate)
      blank? ? alternate : self
  end
end