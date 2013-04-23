# -*- coding: utf-8 -*-
require 'spec_helper'

describe Feed do

  it "should be valid" do
    FactoryGirl.build(:feed).should be_valid
  end

  it "should be invalid" do
    FactoryGirl.build(:feed, feed_url: "www.example.com").should be_invalid
  end

  it "should be invalid" do
    FactoryGirl.build(:feed, feed_url: "http://www.example.com").should be_invalid
  end

  it "should be valid" do
    FactoryGirl.build(:feed, feed_url: "feed://www.whitehouse.gov/feed/press").should be_valid
  end

  it "should be valid" do
    FactoryGirl.build(:feed, feed_url: "www.whitehouse.gov/feed/press").should be_valid
  end

  it "should not be valid without a feed_url" do
    FactoryGirl.build(:feed, feed_url: "").should_not be_valid
  end

  it "should be created" do
    expect { FactoryGirl.create(:feed) }.to change(Feed, :count).by(1)
  end

  it "should have a title" do
    FactoryGirl.build(:feed).should respond_to :title
  end

  it "should have a title" do
    FactoryGirl.create(:feed).title.should be_present
  end

  it "should have a feed_url" do
    FactoryGirl.create(:feed).feed_url.should be_present
  end

  it "should have a feed_url" do
    FactoryGirl.create(:feed).feed_url.should be_present
  end

  it "should have an url" do
    FactoryGirl.create(:feed).url.should be_present
  end

  it "should have a checksum" do
    FactoryGirl.create(:feed).checksum.should be_present
  end

  it "should have feed entries" do
    expect { FactoryGirl.create(:feed) }.to change(FeedEntry, :count).by(30)
  end

  it "should have a valid category" do
    feed = FactoryGirl.create(:feed)
    Feed::CATEGORIES.should have_key(feed.category)
  end

  it "should be destroyed" do
    feed = FactoryGirl.create(:feed)
    expect { feed.destroy }.to change(Feed, :count).by(-1)
  end

  it "should destroy associated feed_entries" do
    feed = FactoryGirl.create(:feed)
    items = feed.feed_entries.size
    expect { feed.destroy }.to change(FeedEntry, :count).by(-items)
  end
end