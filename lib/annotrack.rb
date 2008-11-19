require 'rubygems'
require 'chronic'
require 'open-uri'
require 'yaml'
require 'httparty/lib/httparty'

class Annotrack
  include HTTParty

  attr_accessor :user_name, :project_id, :date

  base_uri "http://www.pivotaltracker.com/services/v1/projects/"
  format :xml

  def initialize(user_name, date, project_id=nil)
    set_api_key_or_die

    @user_name = user_name
    @date = date
    @project_id = project_id
  end

  def accepted_stories
    stories = stories_for_filter(accepted_stories_filter)
  end

  def delivered_stories
    stories = stories_for_filter(delivered_stories_filter)
  end

  def finished_stories
    stories = stories_for_filter(finished_stories_filter)
  end

  def started_stories
    stories = stories_for_filter(started_stories_filter)
  end

  def story_details(story_id)
    response = self.class.get "/#{@project_id}/stories/#{story_id}"
    response['response']['story']
  end

  def summary
    stories = stories_for_date
    stories.each do |story|
      puts message_for_story(story)
    end
    puts
  end


  private

  def accepted_stories_filter
    owner_filter << ' ' << search_filters[:state] << story_states['accepted'] << ' ' << search_filters[:include_done] << 'true'
  end

  def delivered_stories_filter
    owner_filter << ' ' << search_filters[:state] << story_states['delivered']
  end

  def finished_stories_filter
    owner_filter << ' ' << search_filters[:state] << story_states['finished']
  end

  def message_for_story(story)
    status = story['current_state'].upcase
    "#{status}: #{story['name']} (#{story['id']}). "
  end

  def owner_filter
    search_filters[:owner] << %Q("#{@user_name}")
  end

  def search_filters
    {:owner => 'owner:', :state => 'state:', :include_done => 'includedone:'}
  end

  def set_api_key_or_die
    @api_key = settings['api_key']
    raise 'API Key required, add it to config/settings.yml' unless @api_key
    self.class.default_params :token => @api_key
  end

  def settings
    settings_file = File.dirname(__FILE__) + '/../config/settings.yml'
    @settings ||= YAML.load_file settings_file
  end

  def started_stories_filter
    owner_filter << ' ' << search_filters[:state] << story_states['started']
  end

  def stories_for_date
    all_stories = accepted_stories
    all_stories.reject {|story| Chronic.parse(story['accepted_at']) != @date}
  end

  def stories_for_filter(filter)
    response = self.class.get "/#{@project_id}/stories", :query => {:filter => filter}
    stories = response['response']['stories']['story']
    stories.is_a?(Array) ? stories : [stories]
  end

  def story_states
    states = %w(unstarted started finished delivered accepted rejected)
    Hash[*(states.zip(states).flatten)]
  end
end

