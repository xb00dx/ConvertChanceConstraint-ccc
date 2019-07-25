# ConvertChanceConstraint (ccc)
ConvertChanceConstraint (ccc): a Matlab toolbox for Chance-constrained Optimization

## Basic Info
ConvertChanceConstraint (ccc) is a Matlab toolbox built upon [YALMIP](https://yalmip.github.io/). With ccc, users could formulate chance-constrained optimization problems in YALMIP syntax, then ccc converts it to formats that can be solved by YALMIP and compatiable solvers. More details can be found in [docs](./docs).

- **Latest Release** (Work in Progress)
- **Development Version** (`master` branch)
- **Suggested Citation**
If you find *ccc* useful in your work, we kindly request that you cite the following paper 
```
@article{geng2019data,
  title={Data-driven decision making in power systems with probabilistic guarantees: Theory and applications of chance-constrained optimization},
  author={Geng, Xinbo and Xie, Le},
  journal={Annual Reviews in Control},
  year={2019},
  publisher={Elsevier}
}
```

## Installation
1. Install [Matlab](https://www.mathworks.com/products/matlab.html), the latest version is suggested.
2. Install [YALMIP](https://yalmip.github.io/), please follow the instructions guide [here](https://yalmip.github.io/tutorial/installation/)
	- the MPT toolbox is suggested, since it might be used in some robust optimization related methods.
	- [Getting started](https://yalmip.github.io/tutorial/basics/) with YALMIP
3. Add the core functions to Matlab path
	- by *manually* adding the `ConvertChanceConstraint-ccc` or `ConvertChanceConstraint-ccc/code/` folder to Matlab path (by clicking `Home` --> `Set Path` --> `Add with subfolders` --> choose `ConvertChanceConstraint-ccc/code/`.
	- by running the installation script: 
4. Test the installation by running the test code in 

## Bug reports 
- Please report any issues via the Github [issue tracker](https://github.com/xb00dx/ConvertChanceConstraint-ccc/issues).
- All types of issues are welcome and encouraged, e.g. bug reports, documentation typos, feature requests, etc.
- No guarantee on the compatiability with [GNU Octave](https://www.gnu.org/software/octave/).

## Documentation
- An overview of methods to solve Chance-constrained Optimization
- Core functions
- Illustrative examples
- Detailed documentation and its outline