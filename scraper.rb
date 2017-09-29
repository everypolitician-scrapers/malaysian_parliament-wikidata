#!/bin/env ruby
# encoding: utf-8

require 'everypolitician'
require 'wikidata/fetcher'

existing = EveryPolitician::Index.new.country('Malaysia').lower_house.popolo.persons.map(&:wikidata).compact

en_names = EveryPolitician::Wikidata.morph_wikinames(source: 'tmtmtmtm/malaysian_parliament-wp', column: 'wikipedia__en') |
           WikiData::Category.new( 'Category:Members of the Dewan Rakyat', 'en').member_titles
ms_names = WikiData::Category.new( 'Kategori:Ahli Parlimen Malaysia', 'ms').member_titles

EveryPolitician::Wikidata.scrape_wikidata(ids: existing, names: { en: en_names, ms: ms_names })
