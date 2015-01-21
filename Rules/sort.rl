rule sort:
     input:  "{x}.bam"
     output: "{x}.sorted.bam"
     shell:  "/ngs/bin/samtools sort {input} -f {output};"

