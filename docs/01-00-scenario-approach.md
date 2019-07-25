## The Scenario Approach
Consider the following chance-constrained optimization problem,
![](https://latex.codecogs.com/svg.latex?%5Cinline%20%5Cbegin%7Balign*%7D%20%5Cmin_x%7E%26%20c%28x%29%20%5C%5C%20%5Ctext%7Bs.t.%7D%7E%26%20%5Cmathbb%7BP%7D_%5Cxi%5CBig%28%20f%28x%2C%5Cxi%29%20%5Cle%200%20%5CBig%29%20%5Cge%201%20-%20%5Cepsilon%20%5C%5C%20%26%20x%20%5Cin%20%5Cmathcal%7BX%7D%20%5Cend%7Balign*%7D)
It minimizes a cost function c(x) subject to deterministic constraints ![](https://latex.codecogs.com/svg.latex?%5Cinline%20x%20%5Cin%20%5Cmathcal%7BX%7D), while ensuring that ![](https://latex.codecogs.com/svg.latex?%5Cinline%20f%28x%29%20%5Cle%200) holds with probability at least ![](https://latex.codecogs.com/svg.latex?%5Cinline%201-%5Cepsilon).

The scenario approach converts it to the following scenario problem using N scenarios ![N](https://latex.codecogs.com/gif.latex?%5Cinline%20%5Cmathcal%7BN%7D%20%3A%3D%20%5Cxi%5E%7B%281%29%7D%2C%5Cxi%5E%7B%282%29%7D%2C%5Ccdots%2C%5Cxi%5E%7B%28N%29%7D)
![scenario-problem](https://latex.codecogs.com/svg.latex?%5Cinline%20%5Cbegin%7Balign*%7D%20%5Cmin_x%7E%26%20c%28x%29%20%5C%5C%20%5Ctext%7Bs.t.%7D%7E%26%20f%28x%2C%5Cxi%5E%7B%281%29%7D%29%20%5Cle%200%20%5C%5C%20%26%20f%28x%2C%5Cxi%5E%7B%282%29%7D%29%20%5Cle%200%20%5C%5C%20%26%20%5Cvdots%20%5C%5C%20%26%20f%28x%2C%5Cxi%5E%7B%28N%29%7D%29%20%5Cle%200%20%5C%5C%20%26%20x%20%5Cin%20%5Cmathcal%7BX%7D%20%5Cend%7Balign*%7D)
Namely, we find the optimal solution ![](https://latex.codecogs.com/gif.latex?%5Cinline%20x_%7B%5Cmathcal%7BN%7D%7D%5E*) that is feasible to all N scenarios.

### Calculate Sample Complexity
#### A-priori Scenario Approach

#### A-posteriori Scenario Approach


### Find Support Scenarios


### Applications of the Scenario Approach