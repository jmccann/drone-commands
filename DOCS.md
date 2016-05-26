Global Parameters
=================
The following are global parameters used for configuration this plugin:
* **commands** - Commands to run

Example
=======

### Minimal Definition
This will run `ls`

```yaml
deploy:
  commands:
    image: jmccann/drone-commands
    commands:
      - ls
```
