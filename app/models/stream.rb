class Stream < Article

  html_schema_type :BroadcastEvent

  attr_accessor :live
  attr_accessor :live_viewers

  scope :current, -> { order(created_at: :desc).first }

  def self.next_weekly_lunch_and_learn
    friday = (Time.now.beginning_of_week + 4.days)
    event  = Time.new(friday.utc.year, friday.utc.month, friday.utc.day, 9, 30, 0)
    if already_passed = (Time.now > event)
      event + 1.week
    else
      event
    end
  end

  def live?
    live == true
  end

  def self.any_live?
    Rails.cache.fetch('any-streams-live', expires_in: 5.seconds) do
      live.any?
    end
  end

  def self.live_stats(username)
    live_streamers[username]
  end

  def preview_image_url
    "https://api.quickstream.io/coderwall/streams/#{user.username}.png?size=400x"
  end

  def rtmp
    "http://quickstream.io:1935/coderwall/ngrp:#{user.username}_all/jwplayer.smil"
  end

  def self.live
    Stream.where(user: User.where(username: live_streamers.keys)).each do |s|
      s.live = true
    end
  end

  def self.live_streamers
    url = "#{ENV['QUICKSTREAM_URL']}/streams"
    resp = Excon.get(url,
      headers: {
        "Content-Type" => "application/json" },
      idempotent: true,
      tcp_nodelay: true,
    )

    if resp.status != 200
      # TODO: bugsnag
      logger.error "error=quickstream-api-call url=/streams status=#{resp.status}"
      return {}
    end

    JSON.parse(resp.body).each_with_object({}) do |s, memo|
      memo[s['streamer']] = s
    end
  end
end
