rule sam2bam:
    input:  "{x}.sam"
    output: "{x}.bam"
    shell:  "samtools view -bS {input} > {output}"

