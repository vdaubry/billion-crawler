module URI
  def host_with_sublevel_domain
    #http://stackoverflow.com/questions/983158/remove-subdomain-from-string-in-ruby#answer-983558
    regex = /^(?:(?>[a-z0-9-]*\.)+?|)([a-z0-9-]+\.(?>[a-z]*(?>\.[a-z]{2})?))$/i
    host.gsub(regex, '\1').strip
  end
end