### The 1-D point covering problem

- Random samples of ![xi](https://latex.codecogs.com/svg.latex?%5Cinline%20%5Cxi%20%5Cin%20%5Cmathbf%7BR%7D) are drawn from an underlying distribution ![distr](https://latex.codecogs.com/svg.latex?%5Cinline%20%5Cxi%20%5Csim%20%5CXi).
- We would like to find the smallest segment ![seg](https://latex.codecogs.com/svg.latex?%5Cinline%20%5Bx-r%2C%20x&plus;r%5D) (centered at x with radius r) to cover ![](https://latex.codecogs.com/svg.latex?%5Cinline%201-%5Cepsilon) of ![xi](https://latex.codecogs.com/svg.latex?%5Cinline%20%5Cxi).

- The optimization problem can be formulated as

![point-covering](https://latex.codecogs.com/svg.latex?%5Cinline%20%5Cbegin%7Balign*%7D%20%5Cmin_%7Bx%2Cr%7D%7E%26%20r%20%5C%5C%20%5Ctext%7Bs.t.%7D%7E%26%20%5Cmathbb%7BP%7D%20_%7B%5Cxi%7D%20%5CBig%28%20x-r%20%5Cle%20%5Cxi%20%5Cle%20x&plus;r%20%5CBig%29%20%5C%5C%20%26%20r%20%5Cge%200%20%5Cend%7Balign*%7D)

Visually,

![](../figures/points_covering_formulation.png)

#### Feasible Region
The feasible region depends on the underlying distribution ![distr](https://latex.codecogs.com/svg.latex?%5Cinline%20%5Cxi%20%5Csim%20%5CXi). We visualize the feasible for the following two cases

##### Gaussian Distribution 
Assume that ![xi](https://latex.codecogs.com/svg.latex?%5Cinline%20%5Cxi%20%5Cin%20%5Cmathbf%7BR%7D) is drawn from a standard Gaussian distribution N(0,1). Then its feasible region can be visualized

![feasible region (standard gaussian)](../figures/1d_pointcovering_feasibleregion.svg)

Clearly, the optimal solution is x=0 and ![](https://latex.codecogs.com/svg.latex?%5Cinline%20r%3D%20-0.5%20%5CPhi%5E%7B-1%7D%280.5%5Cepsilon%29%20&plus;%200.5%20%5CPhi%5E%7B-1%7D%281-0.5%5Cepsilon%29)


##### Discrete distribution

#### Different Approaches to Solve It

