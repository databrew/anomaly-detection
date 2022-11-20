# run data pipeline:
# 1). do git pull to fetch updates
# 2). run script
pipeline: update scripts

# do git pull
update:
	git pull

# run scripts
scripts:
	Rscript R/cleaning_survey_forms.R
