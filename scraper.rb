#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

en_names = EveryPolitician::Wikidata.morph_wikinames(source: 'tmtmtmtm/malaysian_parliament-wp', column: 'wikipedia__en')
ms_names = WikiData::Category.new( 'Kategori:Ahli Parlimen Malaysia 1959', 'ms').member_titles

EveryPolitician::Wikidata.scrape_wikidata(names: { en: names, ms: ms_names })

