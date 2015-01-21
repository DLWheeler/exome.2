rule flagstats_dedup:
    input:  "{x}.dedup.sorted.bam"
    output: "{x}.dedup.flags"
    shell:  "samtools flagstat {input} > {output}"

