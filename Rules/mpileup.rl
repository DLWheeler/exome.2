rule mpileup:
     input:   "{X}.recal.{Y}"
     output:  "{X}.pileup.recal.{Y}"
     params:  genome=config['references']['GENOME']
     shell: "samtools mpileup -q 1 -f {params.genome} {input} > {output}"

