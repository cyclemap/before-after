#!/bin/bash


<input.geojson \
>main.geojson \
jq \
	--compact-output \
	'
def provideContent:
	"<a target=\"_blank\" href=\"" + . + "\">" + (
		if endswith(".png") or endswith(".jpg") or endswith(".jpeg") then
			"<img style=\"width: 58em\" src=\"" + . + "\" />"
		else
			"<b>link</b>"
		end
	) + "</a>";

	
.features |= map(select(.properties.type != "neither")) |
.features[].properties |= (
	. += {
		"title": .location,
		"description": (
			"<div style=\"positon: absolute; overflow-y:auto; overflow-x: hidden; width: 60em; height: 50em;\">" +

			"<h3>" + .location + "</h3>" +
			
			(.data |map("<p>" + provideContent + "</p>") |join("") ) +
			
			"</div>"
		)
	}
)
'


