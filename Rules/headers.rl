rule headers:
     input:  "{x}.dedup.{Y}"
     output: "{x}.fin.dedup.{Y}"
     run:  rgid=config['samples'][wildcards.x];rgpl=config['platform'];shell('picard-tools AddOrReplaceReadGroups I={input} O={output} RGID={rgid} RGPL={rgpl} RGLB={rgpl} RGPU={rgpl} RGSM={input} RGCN=Melanoma RGDS={input}')
