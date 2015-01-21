rule realign:
        input:  "{x}.fin.{Y}"
        output: re="{x}.realign.fin.{Y}",
                int=temp("{x}.fin.{Y}.intervals")
        params: gatk=config['bin']['GATK'],
                genome=config['references']['GENOME'],
                groot=groot,
                indelsites=config['references']['INDELSITES']
        shell:  "samtools index {input}; samtools faidx {params.genome}; picard-tools CreateSequenceDictionary R={params.genome} O={params.groot}.dict; {params.gatk} -T RealignerTargetCreator -I {input} -R {params.genome} -known {params.indelsites} -o {output.int}; {params.gatk} -T IndelRealigner -R {params.genome} -I {input} -targetIntervals {output.int} -o {output.re}"

