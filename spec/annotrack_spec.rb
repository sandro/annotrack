require File.join(File.dirname(__FILE__), 'spec_helper')

describe Annotrack do
  before :all do
    @track = Annotrack.new('sandro', Date.today, 529)
    #@track = Annotrack.new('bt', Date.today, 1301)
  end

  it 'should have tracker story states' do
    @track.send(:story_states).should be_kind_of(Hash)
  end

  it 'should have tracker search filters' do
    @track.send(:search_filters).should be_kind_of(Hash)
  end

  it 'should create a message for a story' do
    story = {'name' => 'Create drop down list', 'id' => 12345, 'current_state' => 'delivered'}
    message = @track.send(:message_for_story, story)
    message.should == "DELIVERED: Create drop down list (12345). "
  end

  describe 'searches' do
    #it 'should return accepted stories' do
      #stories = @track.accepted_stories
    #end
    it 'should return delivered stories' do
      stories = @track.delivered_stories
      puts stories.inspect
    end
  end

  describe 'filters' do
    it 'should be an owner filter' do
      @track.send(:owner_filter).should == 'owner:"sandro"'
    end

    it 'should include accepted stories and include done' do
      filter = @track.send(:accepted_stories_filter)
      filter.should =~ /state:accepted/
      filter.should =~ /includedone:true/
    end

    it 'should include started stories' do
      filter = @track.send(:started_stories_filter)
      filter.should =~ /state:started/
    end
  end
end
