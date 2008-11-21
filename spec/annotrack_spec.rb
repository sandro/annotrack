require File.join(File.dirname(__FILE__), 'spec_helper')

describe Annotrack do
  before :all do
    @track = Annotrack.new('sandro', Date.today, 529)
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

  describe 'summary' do
    before :each do
      @track.stub!(:puts)
      @stories = [{:id => 1}]
    end

    it 'should find a list of stories for the date' do
      @track.should_receive(:stories_for_date).and_return(@stories)
      @track.stub!(:message_for_story)
      @track.summary
    end

    it 'should print a message for each story found' do
      @track.stub!(:stories_for_date).and_return(@stories)
      @track.should_receive(:message_for_story)
      @track.summary
    end

    it 'should not die if a list of stories could not be found' do
      stories = []
      @track.should_receive(:stories_for_date).and_return(stories)
      @track.summary
    end
  end

  describe 'searches' do
    it 'should return accepted stories' do
      @track.stub!(:accepted_stories_filter).and_return("accepted")
      @track.should_receive(:stories_for_filter).with("accepted")
      @track.accepted_stories
    end

    it 'should return delivered stories' do
      @track.stub!(:delivered_stories_filter).and_return("delivered")
      @track.should_receive(:stories_for_filter).with("delivered")
      @track.delivered_stories
    end

    it 'should return finished stories' do
      @track.stub!(:finished_stories_filter).and_return("finished")
      @track.should_receive(:stories_for_filter).with("finished")
      @track.finished_stories
    end

    it 'should return started stories' do
      @track.stub!(:started_stories_filter).and_return("started")
      @track.should_receive(:stories_for_filter).with("started")
      @track.started_stories
    end

    it 'should return an empty array when no stories are found' do
      @track.class.stub!(:get).and_return({"response"=>{"message"=>"0 stories found for filter 'owner:\"sandro\" state:accepted includedone:true'", "stories"=>"\n  ", "success"=>"true"}})
      response = @track.send(:stories_for_filter, 'filter')
      response.should be_empty
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
