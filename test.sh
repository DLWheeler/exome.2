#!/bin/bash


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

     echo "Now running Snakemake $PipelineType."

