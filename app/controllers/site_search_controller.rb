# -*- coding: utf-8 -*-
require 'open-uri'

class SiteSearchController < ApplicationController
  before_filter { add_body_class "site-search" }

  def index
    @terms = params[:q]
    if @terms.present?
      begin
        client = SiteseekerNormalizer::Client.new(APP_CONFIG['siteseeker']['account'], APP_CONFIG['siteseeker']['index'], encoding: "UTF-8")
        @results = client.search(params.except(:action, :controller))
      rescue Exception => e
        logger.error "Siteseeker: #{e}"
        @error = e
      end
    end

    if request.xhr?
      render :more, layout: false
    else
      render :index
    end
  end

  def autocomplete
    begin
      # Siteseeker is slow and indexing is only done at night so we cache hard
      results = Rails.cache.fetch(Digest::SHA1.hexdigest("search-autocomplete-#{params[:q]}"), expires_in: 12.hours) do
        open("#{APP_CONFIG['site_search_autocomplete_url']}?q=#{CGI.escape(params[:q])}&ilang=sv&callback=results", read_timeout: 1).first
      end
    rescue Exception => e
      logger.error "Siteseeker autocomplete: #{e}"
      # Silent error
      results = 'results({})'
    end
    render json: results
  end
end
