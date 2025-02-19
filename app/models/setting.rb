class Setting < ApplicationRecord
  validates :key, presence: true, uniqueness: true

  default_scope { order(id: :asc) }

  def prefix
    key.split(".").first
  end

  def type
    if %w[feature process proposals map html homepage uploads].include? prefix
      prefix
    else
      "configuration"
    end
  end

  def enabled?
    value.present?
  end

  def content_type?
    key.split(".").last == "content_types"
  end

  def content_type_group
    key.split(".").second
  end

  class << self
    def [](key)
      where(key: key).pluck(:value).first.presence
    end

    def []=(key, value)
      setting = where(key: key).first || new(key: key)
      setting.value = value.presence
      setting.save!
      value
    end

    def rename_key(from:, to:)
      if where(key: to).empty?
        value = where(key: from).pluck(:value).first.presence
        create!(key: to, value: value)
      end
      remove(from)
    end

    def remove(key)
      setting = where(key: key).first
      setting.destroy if setting.present?
    end

    def accepted_content_types_for(group)
      mime_content_types = Setting["uploads.#{group}.content_types"]&.split(" ") || []
      Setting.mime_types[group].select { |_, content_type| mime_content_types.include?(content_type) }.keys
    end

    def mime_types
      {
        "images" => {
          "jpg"  => "image/jpeg",
          "png"  => "image/png",
          "gif"  => "image/gif"
        },
        "documents" => {
          "pdf"  => "application/pdf",
          "doc"  => "application/msword",
          "docx" => "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
          "xls"  => "application/x-ole-storage",
          "xlsx" => "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
          "csv"  => "text/plain",
          "zip"  => "application/zip"
        }
      }
    end

    def defaults
      {
        "feature.featured_proposals": nil,
        "feature.facebook_login": true,
        "feature.google_login": true,
        "feature.twitter_login": true,
        "feature.public_stats": true,
        "feature.signature_sheets": true,
        "feature.user.recommendations": true,
        "feature.user.recommendations_on_debates": true,
        "feature.user.recommendations_on_proposals": true,
        "feature.user.skip_verification": "true",
        "feature.community": true,
        "feature.map": nil,
        "feature.allow_attached_documents": true,
        "feature.allow_images": true,
        "feature.help_page": true,
        "feature.valuation_comment_notification": true,
        "homepage.widgets.feeds.debates": true,
        "homepage.widgets.feeds.processes": true,
        "homepage.widgets.feeds.proposals": true,
        # Code to be included at the top (inside <body>) of every page
        "html.per_page_code_body": "",
        # Code to be included at the top (inside <head>) of every page (useful for tracking)
        "html.per_page_code_head": "",
        "map.latitude": 51.48,
        "map.longitude": 0.0,
        "map.zoom": 10,
        "process.debates": true,
        "process.proposals": true,
        "process.polls": true,
        "process.budgets": true,
        "process.legislation": true,
        "proposals.successful_proposal_id": nil,
        "proposals.poll_short_title": nil,
        "proposals.poll_description": nil,
        "proposals.poll_link": nil,
        "proposals.email_short_title": nil,
        "proposals.email_description": nil,
        "proposals.poster_short_title": nil,
        "proposals.poster_description": nil,
        # Images and Documents
        "uploads.images.title.min_length": 4,
        "uploads.images.title.max_length": 80,
        "uploads.images.min_width": 0,
        "uploads.images.min_height": 475,
        "uploads.images.max_size": 1,
        "uploads.images.content_types": "image/jpeg",
        "uploads.documents.max_amount": 3,
        "uploads.documents.max_size": 3,
        "uploads.documents.content_types": "application/pdf",
        # Names for the moderation console, as a hint for moderators
        # to know better how to assign users with official positions
        "official_level_1_name": I18n.t("seeds.settings.official_level_1_name"),
        "official_level_2_name": I18n.t("seeds.settings.official_level_2_name"),
        "official_level_3_name": I18n.t("seeds.settings.official_level_3_name"),
        "official_level_4_name": I18n.t("seeds.settings.official_level_4_name"),
        "official_level_5_name": I18n.t("seeds.settings.official_level_5_name"),
        "max_ratio_anon_votes_on_debates": 50,
        "max_votes_for_debate_edit": 1000,
        "max_votes_for_proposal_edit": 1000,
        "max_votes_for_people_proposal_edit": 1000,
        "comments_body_max_length": 1000,
        "proposal_code_prefix": "Lucas Cioffi for Town Supervisor",
        "votes_for_proposal_success": 10000,
        "months_to_archive_proposals": 12,
        # Users with this email domain will automatically be marked as level 1 officials
        # Emails under the domain's subdomains will also be included
        "email_domain_for_officials": "",
        "facebook_handle": nil,
        "instagram_handle": nil,
        "telegram_handle": nil,
        "twitter_handle": nil,
        "twitter_hashtag": nil,
        "youtube_handle": nil,
        "url": "http://example.com", # Public-facing URL of the app.
        # CONSUL installation's organization name
        "org_name": "Lucas Cioffi for Town Supervisor",
        "meta_title": nil,
        "meta_description": nil,
        "meta_keywords": nil,
        "proposal_notification_minimum_interval_in_days": 3,
        "direct_message_max_per_day": 3,
        "mailer_from_name": "Lucas Cioffi for Town Supervisor",
        "mailer_from_address": "hello@greenburgh.us",
        "min_age_to_participate": 16,
        "hot_score_period_in_days": 31,
        "related_content_score_threshold": -0.3,
        "featured_proposals_number": 3,
        "dashboard.emails": nil
      }
    end

    def reset_defaults
      defaults.each { |name, value| self[name] = value }
    end

    def add_new_settings
      defaults.each do |name, value|
        self[name] = value unless find_by(key: name)
      end
    end
  end
end
