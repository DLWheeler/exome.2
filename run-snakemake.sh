#!/bin/bash
echo ""
echo ""
echo "****** CCBR Pipeline Launcher ******"
echo "Select a pipeline to run from the list."
echo "Select 'Done' when your choice is correct."
echo ""
echo ""

select choice in exomeseq-pairs rnaseq chipseq genomeseq Done;
do
case $choice in
        "Done")
          echo "Exiting."
          break
          ;;
        *)
          echo "Pipeline will be $choice. Select 'Done' if this is correct."
          PipelineType=$choice
esac
done

echo "Snakemake $PipelineType will be launched. Select 'Go' to continue, 'Abort' to exit."

select choice in Go Abort;
do
case $choice in
        "Abort")
          echo "Exiting."
          exit
          ;;
        *)
          echo "Launching $PipelineType."
          break
esac
done

./makeasnake.py $PipelineType

snakemake --stats QC/Stats;snakemake --rulegraph|dot -Tpng -o QC/workflow.png

cd QC && python stats2html.py
