class Stream < Article
  # include ActiveModel::Model
  # attr_accessor :user, :sources

  # html_schema_type :BroadcastEvent
  attr_accessor :live
  attr_accessor :live_viewers

  scope :current, -> { order(created_at: :desc).first }

  def self.next_weekly_lunch_and_learn
    friday = (Time.now.beginning_of_week + 4.days)
  end

  def self.any_live?
    false
  end

  def self.live_stats(username)
    live_streamers[username]
  end

  def self.live
    Stream.where(user: User.where(username: live_streamers.keys)).each do |s|
      s.live = true
    end
  end

  def preview_image_url
    "https://api.quickstream.io/coderwall/streams/#{user.username}.png?size=400x"
  end

  def rtmp
    "http://quickstream.io:1935/coderwall/ngrp:#{user.username}_all/jwplayer.smil"
  end

  # private

  def self.live_streamers
    resp = Excon.get("#{ENV['QUICKSTREAM_URL']}/streams",
      headers: {
        "Content-Type" => "application/json" },
      idempotent: true,
      tcp_nodelay: true,
    )

    JSON.parse(resp.body).each_with_object({}) do |s, memo|
      memo[s['streamer']] = s
    end
  end
end
