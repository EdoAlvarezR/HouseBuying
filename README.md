# HouseBuying
Calculators for buying a house

Repo Layout

    .
    ├── jupyter/                        # Jupyter notebooks
    └── pluto/                          # Pluto notebooks


## Installation Instructions

### Jupyter Setup

Necessary steps to install Python and Julia kernels
* Install Jupyter with Python kernel:
  ```bash
    pip install jupyter --user
  ```
  > Note: Make sure that [Python scripts are added to PATH](https://datatofish.com/add-python-to-windows-path/) so you can then call `jupyter` from the terminal.
* Download Julia: [LINK](https://julialang.org/downloads/) (make sure Julia gets added to PATH so you can call it from the terminal)
* Install Julia kernel: (in Julia REPL)
  ```julia
    ] add IJulia
  ```


Optional (but recommended) extensions
* Download all Jupyter extensions:
  ```bash
    jupyter contrib nbextension install --user
  ```
* Enable collapsible headings (this allows you to fold/unfold heading
  sections in large notebooks)
  ```
    jupyter nbextension enable collapsible_headings/main
  ```
* Enable hidding input cells (we recommend manually setting shortcut under
  `toggle cell input display` to `h`)
  ```
    jupyter nbextension enable hide_input/main
    jupyter nbextension enable hide_input_all/main
  ```
* Disable bracket auto-completion: [LINK](https://github.com/jupyter/notebook/issues/2040)


### Pluto Setup

* Download Julia: [LINK](https://julialang.org/downloads/)
* Install Pluto: (in Julia REPL)
  ```julia
    ] add Pluto
  ```

## Launch Notebooks

To launch Jupyter:
```bash
  cd /path/to/this/repo
  jupyter notebook
```

To launch Pluto:
```bash
  cd /path/to/this/repo
  julia
    # in julia REPL
    using Pluto
    Pluto.run()
```
