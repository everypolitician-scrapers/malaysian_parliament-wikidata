#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

names = EveryPolitician::Wikidata.morph_wikinames(source: 'tmtmtmtm/malaysian_parliament-wp', column: 'wikipedia__en')
EveryPolitician::Wikidata.scrape_wikidata(names: { en: names })
warn EveryPolitician::Wikidata.notify_rebuilder

