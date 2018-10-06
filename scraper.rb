#!/bin/env ruby
# encoding: utf-8

require 'everypolitician'
require 'wikidata/fetcher'

existing = EveryPolitician::Index.new.country('Malaysia').lower_house.popolo.persons.map(&:wikidata).compact

en_names = WikiData::Category.new( 'Category:Members of the Dewan Rakyat', 'en').member_titles
ms_names = WikiData::Category.new( 'Kategori:Ahli Parlimen Malaysia', 'ms').member_titles

sparq = 'SELECT DISTINCT ?item WHERE { ?item p:P39/ps:P39 wd:Q21290861 }'
p39s = EveryPolitician::Wikidata.sparql(sparq)

EveryPolitician::Wikidata.scrape_wikidata(ids: existing | p39s, names: { en: en_names, ms: ms_names })
