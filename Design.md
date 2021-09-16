# Concept & Design

## Concept
Concept of the this project/automation is simple
- Create a set of App "Templates". These templates have `jinja` templates in it and will form into Splunk apps once Ansible replaces them with details
- These Apps form the basics of Splunk. Remember in Splunk everything is an APP. So no configurations/settings are required, but are part of these Apps
- For example, if you want to create a license server, it contains all of the **CORE** apps & a **LICENSE MASTER** app. That's how it distinguishes from rest of the cluster components
