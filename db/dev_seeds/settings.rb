section "Creating Settings" do
  Setting.reset_defaults

  {
    "facebook_handle": "Lucas Cioffi for Town Supervisor",
    "feature.featured_proposals": "true",
    "feature.map": "true",
    "instagram_handle": "Lucas Cioffi for Town Supervisor",
    "mailer_from_address": "hello@greenburgh.us",
    "mailer_from_name": "Lucas Cioffi for Town Supervisor",
    "meta_description": "Citizen participation tool for an open, "\
                        "transparent and democratic government",
    "meta_keywords": "citizen participation, open government",
    "meta_title": "Lucas Cioffi for Town Supervisor",
    "org_name": "Lucas Cioffi for Town Supervisor",
    "proposal_code_prefix": "MAD",
    "proposal_notification_minimum_interval_in_days": 0,
    "telegram_handle": "Lucas Cioffi for Town Supervisor",
    "twitter_handle": "@consul_dev",
    "twitter_hashtag": "#consul_dev",
    "url": "http://localhost:3000",
    "votes_for_proposal_success": "100",
    "youtube_handle": "Lucas Cioffi for Town Supervisor"
  }.each do |name, value|
    Setting[name] = value
  end
end
