# objective: setup github repo for existing project

# housekeeping
rm(list = ls())

# create a remote on github for the existing project
# reference: https://happygitwithr.com/existing-github-last.html
# If you use the usethis package AND you have configured a GitHub Personal Access Token (PAT) 
# (see the appendix for how to set this up.)
usethis::use_github(host = "https://github.com/")

# generate PAT (personal access token)
# https://github.com/settings/tokens

# store/reset your credentials
# gitcreds_set() adds or updates git credentials in the credential store. 
# It is typically called by the user, and it only works in interactive sessions. 
# It always asks for acknowledgment before it overwrites existing credentials.
# switch between different remotes needs to reset the PAT
gitcreds::gitcreds_set(url = "https://github.com/")

# retrieve your credentials
gitcreds::gitcreds_get(url = "https://github.com/")
