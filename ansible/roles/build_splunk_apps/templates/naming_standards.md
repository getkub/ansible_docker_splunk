## Terminology
|  Format  | Comments   |
|---|---|
| idx  | Indexer(s)
| sh  | Search Head
| shc  | Search Head Cluster
| hf  | Heavy Forwarder
| uf  | Universal Forwarder
| depm  | deployment server
| depr  | deployer


## App level naming standards
|  Format | Example  | Comments   |
|---|---|---|
| COMP_ta_*  | COMP_ta_os_linux  | Any TA elements like props,transforms,eventtypes,tags, macros  |
| COMP_da_*  | COMP_da_soc_dashboards  | Any DA elements like dashboards, views, savedsearches, ui-prefs   |
| COMP_sa_*  | COMP_sa_soc_cim2  | Any SA datamodels, workflows, collections, authorizations/auth   |
| COMP_idx_*  | COMP_idx_custom_indexes  | Any custom indexes you want to create   |
| COMP_inputs_*  | COMP_inputs_cisco_ios  | Any inputs, including scripted inputs, API GET |
| COMP_outputs_*  | COMP_outputs_external_dell  | Any outputs, integrations, API post  |
| COMP_depm_*  | COMP_dep_hf_deployment_serverclass  | Any deployment server type config, eg serverclass |
| COMP_infra_<tier>_  | COMP_infra_shc_limits  | Any core settings like server.conf, distsearch per tier |

## Configuration items standards
|  Format | Example  | Comments   |
|---|---|---|
| comp_db_*  | comp_db_soc_performance  | Dashboards, views, panels  |
| comp_ss_*  | comp_ss_soc_performance1  | SavedSearches   |
| comp_macro_*  | comp_macro_soc_performance  | Macros   |
| comp_macro_*  | comp_macro_soc_performance  | Macros   |
