#!/bin/env ruby
# encoding: utf-8

module EveryPolitician
  
  module Wikidata

    require 'json'
    require 'rest-client'

    def self.morph_wikinames(h)
      morph_api_url = 'https://api.morph.io/%s/data.json' % h[:source]
      morph_api_key = ENV["MORPH_API_KEY"]
      result = RestClient.get morph_api_url, params: {
        key: morph_api_key,
        query: "SELECT DISTINCT(#{h[:column]}) AS wikiname FROM data"
      }
      JSON.parse(result, symbolize_names: true).map { |h| h[:wikiname] }.compact
    end

    #-------------------------------------------------------------------

    require 'wikidata/fetcher'
    require 'scraperwiki'

    def self.scrape_wikidata(h)
      langs = ((h[:lang] || h[:names].keys) + [:en]).flatten.uniq
      langpairs = h[:names].map { |lang, names| WikiData.ids_from_pages(lang.to_s, names) }
      langpairs.each do |people|
        people.each do |name, id|
          data = WikiData::Fetcher.new(id: id).data(langs) rescue nil
          unless data
            warn "No data for #{id}"
            next
          end
          data[:original_wikiname] = name
          ScraperWiki.save_sqlite([:id], data)
        end
      end
    end

    #-------------------------------------------------------------------

    require 'rest-client'

    def self.notify_rebuilder
      RestClient.post ENV['MORPH_REBUILDER_URL'], {} if ENV['MORPH_REBUILDER_URL']
    end
  end
end

# require 'pry'
names = EveryPolitician::Wikidata.morph_wikinames(source: 'tmtmtmtm/malaysian_parliament-wp', column: 'wikipedia__en')
EveryPolitician::Wikidata.scrape_wikidata(names: { en: names })
warn EveryPolitician::Wikidata.notify_rebuilder

