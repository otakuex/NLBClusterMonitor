# NLBClusterMonitor
Monitors the nodes in a Win2012r2 NLB Cluster and emails alerts on changes
- Checks the node counts across multiple clusters
- Compares against expected values
- Counts instances of value difs
- Outputs to HTML report
- Highlights cluster rows with value difs
- Emails list of recipients with "All OK" or "X Issues" in subject line

# Completed tasks
- Build simple web UI for status display
- Build first App API
- Move to Bootstrap Template - https://github.com/puikinsh/CoolAdmin
- Read results from database

# Upcoming modifications
- Store results in database
  - Queryable historic data
- Metrics and trends
- Separate email alerts feature to run then log it in the database
- Make the target servers, epected node values, status check interval, and email recipients editable from the web UI
- Week/month/year summaries for each cluster
- cleanup extraneous files from web

# Action Items for next time
- Lookup cluster identifiers (names, ids, dns, ips, description, whatever) => Rob
- Learn Mongo aggregate pipelines to lookup DBRef values => Ravi


