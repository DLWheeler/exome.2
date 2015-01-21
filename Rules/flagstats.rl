rule flagstats:
    input:  "{x}.bam"
    output: "{x}.flags"
    shell:  "samtools flagstat {input} > {output}"

