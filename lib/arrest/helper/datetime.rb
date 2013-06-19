class DateTime
  def sgdb_iso8061
    self.strftime('%FT%T%z')
  end
end
