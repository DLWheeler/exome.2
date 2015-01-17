#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import markup
import os
import re
date = os.popen('date').read()

V = os.popen('snakemake -v')
v = V.read()

F = open('Stats', 'r')
D = eval(F.read())
page = markup.page()
F.close()

F = open('stats.css', 'r')
CSS = F.read()
F.close()

F = open('toc.js', 'r')
TOC = F.read()
F.close()

F = open('sorttable.js', 'r')
SRT = F.read()
F.close()

title = 'Pipeline Stats'
styles = 'stats.css'
script = ['sorttable.js', 'toc.js']
bodyattrs = {'onload': "generateTOC(document.getElementById('toc'));"}

F = open('../project.json', 'r')
P = eval(F.read())
F.close()
pid = P['project']['id']
org = P['project']['organism']
user = P['project']['analyst']
pipeline = P['project']['pipeline']
pipeline_ver = P['project']['version']

page.init(title=title, css=styles, bodyattrs=bodyattrs, script=script)

page.init(title=title, bodyattrs=bodyattrs)

nsamp = len(P['samples'])

page.h1('Project: <i>{}</i> with {} samples'.format(pid, nsamp))
page.h5('Date: <i>{}</i>'.format(date))
page.h5('Organism: <i>{}</i>'.format(org))
page.h5('Analyst: <i>{}</i>'.format(user))
page.h5('Pipeline: <i>{}</i>'.format(pipeline))
page.h5('Pipeline Version: <i>{}</i>'.format(pipeline_ver))
page.h5('Snakemake Version: <i>{}</i>'.format(v))

page.h2('Contents')
page.add("<div id='toc'></div>")

page.h2('Pipeline Flow Diagram')
page.img(src='workflow.png')

page.h2('Execution Times for Rules')
page.add("<table cols=2 class='sortable'>")
page.th(['Rule', 'Average Duration', 'Maximum Duration',
        'Minimum Duration'])
for k in D['rules'].keys():
    page.ul('<tr><td>{}</td><td>{}</td><td>{}</td><td>{}</td></tr>'.format(k,
            D['rules'][k]['mean-runtime'], D['rules'][k]['max-runtime'
            ], D['rules'][k]['min-runtime']))

page.table.close()

page.h2('Starts, Stops, and Processing Times for Files')
page.h3('Total Computing Time for Pipeline: {}'.format(D['total_runtime'
        ]))
page.add("<table cols=4 class='sortable'>")

page.add('<tr>')
page.th(['File', 'Start', 'Stop', 'Duration'])
page.add('</tr>')
for k in D['files'].keys():
    page.add('<tr><td>{}</td><td>{}</td><td>{}</td><td>{}</td></tr>'.format(k,
             D['files'][k]['start-time'], D['files'][k]['stop-time'],
             D['files'][k]['duration']))

page.table.close()
F.close()

page.h2('Contents of <i>project.json</i>')
page.add("<table cols=2 class='sortable'>")

page.add('<tr>')
page.th(['Parameter', 'Value'])
page.add('</tr>')
for k in P.keys():
    T = '<table>'
    try:
        for k2 in P[k].keys():
            T2 = '<table>'
            try:
                for k3 in P[k][k2].keys():
                    T2 = T2 \
                        + '<tr><td>{}</td><td>{}</td></tr>'.format(k3,
                            P[k][k2][k3])
                T2 = T2 + '</table>'
            except:
                T2 = P[k][k2]

            T = T + '<tr><td>{}</td><td>{}</td></tr>'.format(k2, T2)
        T = T + '</table>'
    except:
        T = P[k]

    page.add('<tr><td>{}</td><td>{}</td></tr>'.format(k, T))

page.table.close()

page.h2('Samtools FlagStat Output for Original Reads Passing QC')

F = open('align_qc.tab', 'r')
T = F.read().replace('"', '')

TA = T[:T.find('\n')]
TB = T[T.find('\n') + 1:]

TB = TB.replace('\n', '<tr><td>')
TB = TB.replace('\t', '</td><td>')
TB = '<tr><td>' + TB
TB = TB[0:len(TB) - 4] + '</td>'

TA = TA.replace('\t', '</th><th>')
TA = '<tr><th>Read Category</th><th>' + TA + '</th></tr>'

page.add("<table class='sortable'>")

page.add(TA)
page.add(TB)

page.table.close()

page.h2('Samtools FlagStat Output for Deduped Reads Passing QC')

F = open('align_qc2.tab', 'r')
T = F.read().replace('"', '')

TA = T[:T.find('\n')]
TB = T[T.find('\n') + 1:]

TB = TB.replace('\n', '<tr><td>')
TB = TB.replace('\t', '</td><td>')
TB = '<tr><td>' + TB
TB = TB[0:len(TB) - 4] + '</td>'

TA = TA.replace('\t', '</th><th>')
TA = '<tr><th>Read Category</th><th>' + TA + '</th></tr>'

page.add("<table class='sortable'>")

page.add(TA)
page.add(TB)

page.table.close()

page.h3('Stacked bar graph with three sections for each sample.')
page.pre('From bottom of bar: all reads, those aligned, those aligned with proper mate pair alignment.'
         )

page.img(src='align_qc.png')

page.h2('Read Coverage Histograms')

for sample in sorted(P['samples'].keys()):
    for chr in ["M"]+map(str,range(1,23))+["X","Y"]:
        page.h3('Coverage Histogram for <i>' + sample + ', chr'+chr+'</i>')
        page.img(src=sample + '.chr'+chr+'.coverage.png')


page.h2('Read Coverage Graphs')

for sample in sorted(P['samples'].keys()):
    for chr in ["M"]+map(str,range(1,23))+["X","Y"]:
        page.h3('Coverage Graph for <i>' + sample + ', chr'+chr+'</i>')
        page.img(src=sample +'.chr'+chr+ '.depth.png')


G = open('Stats.html', 'w')

G.write(str(page))
G.close()
