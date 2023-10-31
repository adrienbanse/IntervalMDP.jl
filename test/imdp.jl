# Matrix
prob1 = MatrixIntervalProbabilities(;
    lower = [
        0.0 0.5
        0.1 0.3
        0.2 0.1
    ],
    upper = [
        0.5 0.7
        0.6 0.5
        0.7 0.3
    ],
)

prob2 = MatrixIntervalProbabilities(;
    lower = [
        0.1 0.2
        0.2 0.3
        0.3 0.4
    ],
    upper = [
        0.6 0.6
        0.5 0.5
        0.4 0.4
    ],
)

prob3 = MatrixIntervalProbabilities(;
    lower = [
        0.0
        0.0
        1.0
    ][:, :],
    upper = [
        0.0
        0.0
        1.0
    ][:, :],
)

action_list = ["a1", "a2", "a1", "a2", "sinking"]
initial_state = Int32(1)

mdp = IntervalMarkovDecisionProcess([prob1, prob2, prob3], action_list, initial_state)

# Finite time reachability
problem = Problem(mdp, FiniteTimeReachability([3], 3, 10))
V_fixed_it1, k, _ = interval_value_iteration(problem; maximize = true, upper_bound = false)
@test k == 10

V_fixed_it2, k, _ = interval_value_iteration(problem; maximize = true, upper_bound = true)
@test k == 10
@test all(V_fixed_it1 .<= V_fixed_it2)

V_fixed_it1, k, _ = interval_value_iteration(problem; maximize = false, upper_bound = false)
@test k == 10

V_fixed_it2, k, _ = interval_value_iteration(problem; maximize = false, upper_bound = true)
@test k == 10
@test all(V_fixed_it1 .<= V_fixed_it2)

# Infinite time reachability
problem = Problem(mdp, InfiniteTimeReachability([3], 3, 1e-6))
V_conv, _, u = interval_value_iteration(problem; maximize = true, upper_bound = false)
@test maximum(u) <= 1e-6

# Finite time reach avoid
problem = Problem(mdp, FiniteTimeReachAvoid([3], [2], 3, 10))
V_fixed_it1, k, _ = interval_value_iteration(problem; maximize = true, upper_bound = false)
@test k == 10

V_fixed_it2, k, _ = interval_value_iteration(problem; maximize = true, upper_bound = false)
@test k == 10
@test all(V_fixed_it1 .<= V_fixed_it2)

V_fixed_it1, k, _ = interval_value_iteration(problem; maximize = false, upper_bound = false)
@test k == 10

V_fixed_it2, k, _ = interval_value_iteration(problem; maximize = false, upper_bound = false)
@test k == 10
@test all(V_fixed_it1 .<= V_fixed_it2)

# Infinite time reach avoid
problem = Problem(mdp, InfiniteTimeReachAvoid([3], [2], 3, 1e-6))
V_conv, _, u = interval_value_iteration(problem; maximize = true, upper_bound = false)
@test maximum(u) <= 1e-6