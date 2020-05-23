*! version 1.0.0  12jul1995
program define gphview
	version 5.0
	cap noisily window fopen D_gph "Select a graph to view:" "StataQuest Graphs (*.gph)|*.gph|All Files (*.*)|*.*" "*.gph"
	if _rc==0 {
		di in wh "graph using" _quote "$D_gph" _quote
		window push graph using $D_gph
		graph using "$D_gph"
	}
end
