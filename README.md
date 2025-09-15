# Monte Carlo Estimation of Pi

This project demonstrates how to estimate the value of π using the **Monte Carlo method** in MATLAB.  
It includes three implementations:
1. For-loop implementation - step-by-step estimation and performance tracking.  
2. While-loop implementation with a convergence-based stopping criterion.  
3. Reusable function `monteCarloPi(sigfigs)` – estimates π to a desired number of significant figures with live plotting.


# How It Works

The Monte Carlo method uses **random sampling** to approximate mathematical values.  

When it comes to estimating the value of pi...
- Imagine a quarter of a circle (radius = 1) drawn inside a unit square.  
- The area of the quarter circle is pi/4, and the area of the square is 1.  
- If we randomly generate points inside the square:  
  - The probability that a point lies inside the quarter circle is pi/4.  
  - Thus, we can approximate pi using this information.

As the number of points increases, the estimate **converges to the true value of π**.  


# Requirements

- MATLAB R2022b or later (earlier versions should also work).  
- No additional toolboxes required (only built-in MATLAB functions).


# Usage

### Run the whole script
Simply run the script file in MATLAB.

