rule map_pe:
    input:  config['references']['GENOME']+".bwt",config['references']['GENOME'], 
            "{x}.R1.fastq",
            "{x}.R2.fastq"
    output: "{x}.sam"
    params: bwa=config['bin']['BWA']
    shell:  "{params.bwa} mem {input[1]} {input[2]} {input[3]} > {output}"

