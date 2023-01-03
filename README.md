# pcsFilter (Pre-Alpha)
Tool for filtering out **P**ython **C**ode **S**mells

---

**pcsFilter** is a wrapper around: 
1. [blue](https://pypi.org/project/blue/)
2. [isort](https://pypi.org/project/isort/)
3. [flake8](https://pypi.org/project/flake8/)
4. [radon](https://pypi.org/project/radon/) (Cyclomatic Complexity "cc" command)

pcsFilter runs mentioned tools in a given order. The following functionality is applied on top:

1. _flake8_ and _radon cc_ scores and their details are saved upon the first run to
   _.pcsFilter_ folder by default. The default folder path can be overriden via
   the output path option (`-o` or `--output-path`).
2. When _pcsFilter_ is executed again the new scores is compared with the previous ones.
3. If new scores are worse then: 
   1. a short message will be printed
   2. if "strict" (`-s` or `--strict`) option is used then:
      - _pcsFilter_ will exit with status = 1
4. New scores and their details will be saved to a default or given output path.

## Usage
### Quick
```shell
pip install pcsFilter
pcsFilter <path to project or file>
```

### Strict
Fail with status = 1, when new scores are worse. Has no effect during the first run.
```shell
pcsFilter -s <path to project or file>
pcsFilter --strict <path to project or file>
```

### Override output path
Use this option when default path to `.pcsFilter` is not acceptable.
```shell
pcsFilter -o <new output path> <path to project or file>
pcsFilter --output-path <new output path> <path to project or file>
```

### Help
Print help message
```shell
pcsFilter --help
```

## Contributing
Any contribution is always welcome!  
Please follow [this code of conduct](./CODE_OF_CONDUCT.md).  
[This doc](./CONTRIBUTING.md) explains contribution details.
