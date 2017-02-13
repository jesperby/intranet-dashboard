# -*- coding: utf-8 -*-

# News feeds
class Feed < ActiveRecord::Base
  attr_accessible :title, :feed_url, :category, :role_ids
  attr_reader :parsed_feed

  CATEGORIES = {
    "news" => "nyheter",
    "dialog" => "diskussioner",
    "feature" => "tema",
    "maintenance_warnings" => "driftsmeddelanden",
    "my_own" => "användare"
  }

  has_and_belongs_to_many :roles
  has_and_belongs_to_many :users
  has_many :feed_entries, dependent: :destroy

  before_validation do
    # Fetch and parse feed, to get appropriate validation messages
    if fetch_and_parse
      map_feed_attributes
    end
  end

  after_update :delete_stale_feed_entries

  def delete_stale_feed_entries
    # Remove feed entries that isn't in the feed anymore
    if APP_CONFIG['feed_worker']['purge_stale_entries']
      FeedEntry.where(feed_id: id).where.not(id: fresh_feed_entries.map(&:id)).delete_all
    end
  end

  def fetch_and_parse
    fix_url
    begin
      @parsed_feed = Feedjira::Feed.fetch_and_parse(feed_url, http_options)
      if @parsed_feed === 304
        false
      elsif @parsed_feed.is_a?(Fixnum) || @parsed_feed.blank?
        errors.add(:feed_url, "Flödet kunde inte hämtas eller var ogiltigt. Kontrollera att det är ett giltigt RSS- eller Atom-flöde.")
        false
      else
        true
      end
    rescue Exception => e
      errors.add(:feed_url, "Flödet kunde inte hämtas eller var ogiltigt. Kontrollera att det är ett giltigt RSS- eller Atom-flöde.")
      logger.info "Feedjira: #{e}. Feed id: #{id}, #{feed_url}"
      false
    end
  end

  # Create or update feed entries for the feed
  def fresh_feed_entries
    @parsed_feed.entries.map do |parsed_entry|
      # Don't store enties that are more than max_age old
      next if parsed_entry.published < APP_CONFIG['feed_worker']['max_age'].days.ago

      entry = FeedEntry.where(guid: parsed_entry.entry_id, feed_id: id).first_or_initialize
      entry.published      = parsed_entry.published
      entry.url            = parsed_entry.url
      entry.title          = parsed_entry.title.present? ? parsed_entry.title[0...191] : 'Utan titel'
      entry.summary        = parsed_entry.summary
      entry.count_comments = parsed_entry.count_comments
      entry.image          = parsed_entry.image
      entry.image_medium   = parsed_entry.image_medium
      entry.image_large    = parsed_entry.image_large
      entry
    end.compact
  end

  def map_feed_attributes
    self.title            = @parsed_feed.title.present? ? @parsed_feed.title[0...191] : 'Utan titel'
    self.url              = @parsed_feed.url
    self.fetched_at       = Time.now
    self.last_modified    = @parsed_feed.last_modified
    self.etag             = @parsed_feed.etag
    self.recent_skips     = 0
    self.recent_failures  = 0
    self.feed_entries << fresh_feed_entries
  end

  # Delete feed_entries, fetch, parse and save
  def refresh_entries
    feed_entries.delete_all
    self.fetched_at = nil
    self.etag = nil
    self.last_modified = nil
    self.save
  end

  private
    # Pre-parsing and fixing of a feed url, manipulate it for some special cases
    def fix_url
      # Remove Safari’s pseudo protocol
      self.feed_url.gsub!(/^feed:\/\//, '')

      # Convert #<hashtag(s)> to a twitter search feed for given hash tag(s)
      if feed_url.match(/^#/)
        self.feed_url = "http://search.twitter.com/search.rss?q=#{URI.escape(feed_url)}"

      # Convert @user to a twitter search feed for that user
      elsif feed_url.match(/^@/)
        feed_url.gsub!(/@/, '')
        self.feed_url = "http://twitter.com/statuses/user_timeline/#{URI.escape(feed_url)}.rss"

      # Convert shortnames to a Komin blog feed
      elsif feed_url.present? && !feed_url.match(/[\.\/]/)
        self.feed_url = "http://kominblogg.malmo.se/author/#{URI.escape(feed_url)}/feed/"

      # Add http:// if not there. Allow file:// for specs
      else
        self.feed_url = "http://#{feed_url}" unless feed_url.match(/^(https?|file):\/\//)
      end
    end

    def http_options
      options = {
        timeout: 5,
        compress: true,
        nosignal: true,
        ssl_verify_peer: false,
        ssl_verify_host: false
      }
      options[:if_none_match] = etag if etag?
      options[:if_modified_since] = last_modified if last_modified?
      options
    end
end
