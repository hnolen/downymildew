######RESOURCES USED#####
#https://bioc.ism.ac.jp/packages/3.2/bioc/vignettes/ggtree/inst/doc/treeVisualization.html
#https://bioc.ism.ac.jp/packages/3.2/bioc/vignettes/ggtree/inst/doc/treeManipulation.html
#https://bioc.ism.ac.jp/packages/3.2/bioc/vignettes/ggtree/inst/doc/treeAnnotation.html
#https://yulab-smu.github.io/treedata-book/chapter9.html
#https://yulab-smu.github.io/treedata-book/chapter7.html#attach-operator


#Load libraries (only do once)

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install(c("Biostrings", "ggtree"))

##Packages to load:

library("maps")
library("phytools")
library("ape")
library("treeio")
library("ggtree")
library("Biostrings")
library("ggplot2")
library("phangorn")
library("geiger")
library("RColorBrewer")
library("ggrepel")
library("ggtext")
library("shiny")


###RANDOM NOTES:
#labels internal nodes
#use branch.length="none" in the ggtree() to ignore branch lengths
# + geom_treescale() shows the evolutionary distance
# + geom_tiplab() displays labels for tips
# + geom_nodelab(geom='label') displays bootstrap values for each node (for tree files with metadata)
# + geom_tippoint(aes(shape = host), size=2)
# theme(legend.position = "right")

##Tree for 2018 isolates:
pvariabilis_tree <- read.tree("trimmed_2018_outgroups.phylip.treefile")
pvariabilis_tree

#root tree - if you get an error here make sure the outgroup name here matches what is written in tree file
rooted_tree <- root(pvariabilis_tree, outgroup = "AF196636_1_Pythium_ultimum", node = NULL, resolve.root=TRUE, interactive=FALSE,edgelabels=FALSE)
rooted_tree

ggtree(rooted_tree) %<+% metadata18 +
  geom_treescale(width=0.08) +
  geom_tiplab(aes(label = tip_label, color = host), size=5, show.legend=FALSE) +
  #scale_color_brewer("host", palette = "Dark2") + #using this doesn't give you control of which tips get which color
  #used Dark 2 palette hex codes
  #see brewer.pal(n = 8, name = "Dark2") for these
  scale_colour_manual(values = c("#66A61E","#D95F02", "#1B9E77", "#666666")) + #had to play around with the order of these colors to get the correct color-coding that I wanted. See https://www.datanovia.com/en/blog/top-r-color-palettes-to-know-for-great-data-visualization/
  #next line labels the bootstrap values that were over 70
  geom_text2(aes(label=label, subset = !is.na(as.numeric(label)) & as.numeric(label) > 70), nudge_x=-0.005, nudge_y=0.15) +
  expand_limits(x=0.5)


##Tree for 2019 isolates:
pvariabilis_tree <- read.tree("trimmed_2019_isolates_outgroups.phylip.treefile")
pvariabilis_tree

#root tree
rooted_tree <- root(pvariabilis_tree, outgroup = "AF196636_1_Pythium_ultimum", node = NULL, resolve.root=TRUE, interactive=FALSE,edgelabels=FALSE)
rooted_tree

ggtree(rooted_tree) %<+% metadata19 +
  geom_treescale(width = 0.08) +
  geom_tiplab(aes(label = tip_label, color = host), size=5, show.legend=FALSE) +
  #scale_color_brewer("host", palette = "Set1") +
  scale_colour_manual(values = c("#7570B3","#D95F02","#1B9E77","#666666")) +
  #geom_text2(aes(label=label))
  geom_text2(aes(label=label, subset = !is.na(as.numeric(label)) & as.numeric(label) > 90), nudge_x=-0.005, nudge_y = 0.2) +
  #geom_text2(aes(subset=!isTip, label=node), hjust=-.9) + #gets the uniqe node number ggtree uses
  #geom_hilight(node=17, fill = "steelblue", alpha = 0.3, extend = 10) + #highlights a certain clade
  expand_limits(x=0.5) 


##Tree for 2018 and 2019 isolates:
pvariabilis_tree <- read.tree("trimmed_2018_2019.phylip.treefile")
pvariabilis_tree

#root tree
rooted_tree <- root(pvariabilis_tree, outgroup = "AF196636_1_Pythium_ultimum", node=NULL, resolve.root=TRUE, interactive=FALSE,edgelabels=FALSE)
rooted_tree

ggtree(rooted_tree) %<+% metadata +
  geom_treescale(width=0.08, y = -0.1) +
  geom_tiplab(aes(label = tip_label, color = host),size=5, show.legend=FALSE) +
  #geom_tiplab(aes(label = species, color = host), fontface='italic',geom = 'text', size=5, show.legend=FALSE) +
  #geom_label_repel(aes(aes = TRUE, label=species, color = host), fontface='italic',geom = 'text', show.legend=FALSE) +
  #scale_color_brewer("host", palette = "Dark2") +
  scale_colour_manual(values = c("#66A61E", "#7570B3", "#D95F02","#1B9E77", "#666666")) +
  #geom_text2(aes(subset=!isTip, label=node), hjust=-12) + #gets the uniqe node number ggtree uses
  geom_hilight(node=37, fill = "steelblue", alpha = 0.3, extend = 1) + #highlights a certain clade
  #geom_hilight(node=38, fill = "orange", alpha = 0.3, extend = 1) + #highlights a certain clade
  #geom_text2(aes(label=label))
  geom_text2(aes(label=label, subset = !is.na(as.numeric(label)) & as.numeric(label) > 71), nudge_x=-0.015, nudge_y=0.4) +
  expand_limits(x=0.5, y=0.01) 

##this tree here I didn't use - this ladderizes branches and then branch lengths basically mean nothing
ggtree(rooted_tree, ladderize=TRUE, branch.length="none") %<+% metadata + 
  geom_nodelab(nudge_x = -0.02, geom='label') + 
  geom_treescale() + 
  geom_tiplab(aes(color = host),size=5, show.legend = FALSE) + 
  scale_color_brewer("host", palette = "Dark2") +
  #geom_text2(aes(subset=!isTip, label=node), hjust=-.9) + #gets the uniqe node number ggtree uses
  #geom_hilight(node=38, fill = "steelblue", alpha = 0.3, extend = 15) + #highlights a certain clade
  geom_cladelabel(38, label = "Clade I", offset = 10) +
  geom_cladelabel(42, label = "Clade III", offset = 8) +
  theme(legend.position = "right") + 
  expand_limits(x=60)


##Tree for all isolates

pvariabilis_tree <- read.tree("trimmed_sa_2018_2019_penn_outgroups.phylip.treefile")
pvariabilis_tree

#root tree
rooted_tree <- root(pvariabilis_tree, outgroup = "AF196636_1_Pythium_ultimum", node=NULL, resolve.root=TRUE, interactive=FALSE,edgelabels=FALSE)
rooted_tree

ggtree(rooted_tree) %<+% all_metadata +
  geom_treescale(y=-0.8, x=0.05, width = 0.08) +
  geom_tiplab(aes(label = tip_label, color = location), size=5, show.legend=FALSE) +
  #geom_tiplab(aes(label = species, color = location), size=5, fontface='italic', show.legend=FALSE) +
  scale_colour_manual(values = c("#666666", "#66A61E", "#7570B3", "#D95F02")) +
  #scale_color_brewer("host", palette = "Dark2") +
  #geom_text2(aes(label=label))
  geom_text2(aes(label=label, subset = !is.na(as.numeric(label)) & as.numeric(label) > 80), nudge_y=0.5, nudge_x = -0.015) +
  expand_limits(x=1) 
  #geom_text2(aes(subset=!isTip, label=node), hjust=-.9) #gets the uniqe node number ggtree uses



#to rotate nodes:   
#tree2<-rotate(tree, 69) %>% rotate(53)
