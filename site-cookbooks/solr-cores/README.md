solr-cores Cookbook
===================
Creates Solr cores for Solr >= 4.4

Requirements
------------
The current implementation depends on solr being installed using the 
[hipsnip-solr](https://github.com/hipsnip-cookbooks/solr) cookbook,
as it uses attributes that are set durring installation.

It also uses the new-style core configuration, introduced in Solr 4.4.

Usage
-----
#### sqlite-dev::default
Just include `sqlite-dev` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[sqlite-dev]"
  ]
}
```

License and Authors
-------------------
Authors: Reid Beels
