require 'hpricot'
# optional rake task to assist in generating project names and ids
# parses project listings from http://www.pivotaltracker.com/projects
# download the html from that page and place it in config/projects.html
desc 'get project listing'
task :list_projects do
  doc = Hpricot(open('config/projects.html'))
  projects = {}
  project_links = doc.search('.project_column a')
  project_links.each do |link|
    projects[link.inner_text] = link.attributes['href'].slice(/\d+/).to_i
  end
  puts "Projects Hash"
  puts projects.inspect
end
