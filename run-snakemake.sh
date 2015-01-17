#!/bin/sh
snakemake --stats QC/Stats;snakemake --rulegraph|dot -Tpng -o QC/workflow.png
cd QC && python stats2html.py
