#!/usr/bin/env python

import sys

PipelineType=sys.argv[1]

C=open("project.json","r")
config=eval(C.read())

G=open(config['final'][PipelineType],"r")
All=G.read()
T=open("snakefile.template","r")
Template=T.read()

F=open("Snakefile","w")
F.write(Template+"\n")
F.write(All+"\n")

for R in sorted(config['rules'].keys()):
    if PipelineType in config['rules'][R]:
        F.write("include: \""+"Rules/"+R+".rl\"\n")

F.close()




