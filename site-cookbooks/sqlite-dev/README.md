sqlite-dev Cookbook
===================
Installs the libsqlite3-dev headers on Ubuntu

Requirements
------------
Only tested on ubuntu, requires `apt`

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
