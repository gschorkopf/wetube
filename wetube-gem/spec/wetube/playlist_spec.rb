require 'spec_helper'
require 'pry'

describe Wetube::Playlist do
  describe ".find" do
    before(:each) do
      response  = "{\"id\":1,\"created_at\":\"2013-06-13T21:41:22Z\",\"videos\":[{\"duration\":null,\"id\":1,\"title\":\"Something\",\"uploaded_at\":null,\"uploader\":null,\"url\":\"http://www.youtube.com/something\"},{\"duration\":null,\"id\":2,\"title\":\"Something else\",\"uploaded_at\":null,\"uploader\":null,\"url\":\"http://www.youtube.com/something_else\"}]}"
      response2 = "[{\"created_at\":\"2013-06-28T16:19:42Z\",\"id\":1,\"playlist_id\":1,\"status\":\"played\",\"updated_at\":\"2013-06-28T17:08:25Z\",\"video_id\":1},{\"created_at\":\"2013-06-28T16:19:43Z\",\"id\":2,\"playlist_id\":1,\"status\":\"played\",\"updated_at\":\"2013-06-28T17:08:31Z\",\"video_id\":1}]"
      Wetube::Server.stub(:get_resource).and_return(response, response2)
    end

    it "returns a hashie of found playlist" do
      result = described_class.find(1)
      expect(result.id).to eq 1
      expect(result.created_at).to eq "2013-06-13T21:41:22Z"
    end

    it "returns all videos belonging to the playlist" do
      result = described_class.find(1)
      expect(result.videos.first.title).to eq 'Something'
    end
  end

  describe ".find_or_create_video" do
    before :each do
      response = "{\"duration\":null,\"id\":2,\"title\":\"Something else\",\"uploaded_at\":null,\"uploader\":null,\"url\":\"http://www.youtube.com/something_else\"}"
      Wetube::Server.stub(:post_resource).and_return(response)
    end

    it "finds/creates and returns hashie of video" do
      result = described_class.find_or_create_video(1, {title: "Stubbed", url: "Stubbed"})
      expect(result.title).to eq "Something else"
    end
  end

  describe ".get_video_id" do
    it "gets the video id from a youtube url string" do
      url = "http://www.youtube.com/?v=1"
      expect(described_class.get_video_id(url)).to eq '1'
    end
  end
end