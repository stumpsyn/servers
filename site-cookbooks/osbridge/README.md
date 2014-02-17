Open Source Bridge Cookbook
===========================
Sets up various custom configuration for running opensourcebridge.org

Usage
-----
#### osbridge::default
Just include `osbridge` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[osbridge]"
  ]
}
```

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Reid Beels
