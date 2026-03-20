godot --export-release "Web"
godot --export-release "Win"
butler push ../exports/squap/Web freedom/squap-demo:html5
butler push ../exports/squap/Win freedom/squap-demo:windows